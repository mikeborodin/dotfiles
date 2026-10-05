from datetime import datetime

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.rgb import to_color
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_tab_with_powerline,
)

# Colors matching Catppuccin Macchiato / Wezterm config
TAB_BAR_BG = "#181926"
ACTIVE_TAB_BG = "#383d6d"
ACTIVE_TAB_FG = "#ffffff"
NORMAL_TAB_BG = "#191f26"
NORMAL_TAB_FG = "#808080"
SESSION_BG = "#c6a0f6"
SESSION_FG = "#181926"
RIGHT_CWD_BG = "#1b1e2e"
RIGHT_CWD_FG = "#b8c0e0"
RIGHT_TIME_BG = "#141724"
RIGHT_TIME_FG = "#b8c0e0"

REFRESH_TIME = 1

# Cache for whether session indicator was already drawn this render cycle
_session_drawn_for_cycle = {"cycle_id": -1}


def _get_active_session_name() -> str:
    boss = get_boss()
    if boss is None:
        return ""
    return boss.active_session or ""


def _draw_session_indicator(screen: Screen, draw_data: DrawData) -> int:
    """Draw the session name indicator at the left of the tab bar."""
    session = _get_active_session_name()
    if not session:
        return screen.cursor.x

    # Strip path and extension to get clean name
    name = session.rsplit("/", 1)[-1]
    for suffix in (".kitty-session", ".kitty_session", ".session"):
        if name.endswith(suffix):
            name = name[: -len(suffix)]
            break

    if not name:
        return screen.cursor.x

    draw_attributed_string(Formatter.reset, screen)
    session_bg = as_rgb(int(to_color(SESSION_BG)))
    session_fg = as_rgb(int(to_color(SESSION_FG)))
    default_bg = as_rgb(int(to_color(TAB_BAR_BG)))

    # Draw: " session_name "
    screen.cursor.bg = session_bg
    screen.cursor.fg = session_fg
    screen.cursor.bold = True
    screen.draw(f"  {name} ")
    screen.cursor.bold = False

    # Powerline arrow from session indicator to tab bar background
    screen.cursor.fg = session_bg
    screen.cursor.bg = default_bg
    screen.draw("\ue0b0")  # 

    return screen.cursor.x


def _get_active_cwd() -> str:
    boss = get_boss()
    if boss is None or boss.active_window is None:
        return ""

    w = boss.active_window
    for attr in ("cwd_of_child", "current_cwd", "cwd"):
        val = getattr(w, attr, None)
        if callable(val):
            try:
                val = val()
            except Exception:
                val = None
        if isinstance(val, str) and val:
            home = "~"
            try:
                from os.path import expanduser

                user_home = expanduser("~")
                if user_home and val.startswith(user_home):
                    val = val.replace(user_home, home, 1)
            except Exception:
                pass
            return val

    return ""


def _is_custom_tab_title(tab: TabBarData) -> bool:
    title = (getattr(tab, "title", "") or "").strip()
    if not title:
        return False

    active_exe = (getattr(tab, "active_exe", "") or "").strip()
    active_wd = (getattr(tab, "active_wd", "") or "").strip()
    wd_name = active_wd.rstrip("/").rsplit("/", 1)[-1] if active_wd else ""

    t = title.lower()
    exe = active_exe.lower()
    wd = active_wd.lower()
    wd_base = wd_name.lower()

    # Common auto-generated titles (cwd/exe based)
    if title in {
        active_exe,
        active_wd,
        wd_name,
        f"{active_exe} · {active_wd}" if active_exe and active_wd else "",
        f"{active_exe} · {wd_name}" if active_exe and wd_name else "",
    }:
        return False

    # Heuristic: if title clearly references cwd/exe, treat as auto-title
    if exe and exe in t:
        return False
    if wd and (wd in t or t in wd):
        return False
    if wd_base and wd_base in t:
        return False
    if "/" in title or title.startswith("~"):
        return False

    return True


def _tab_label(tab: TabBarData, index: int) -> str:
    if _is_custom_tab_title(tab):
        title = (getattr(tab, "title", "") or "").strip()
        if title.lower().startswith("tab name:"):
            title = title[len("tab name:") :].strip()
        return title
    # kitty passes zero-based index to draw_tab()
    return str(index + 1)


def _draw_right_status(screen: Screen, is_last: bool, draw_data: DrawData) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)

    cwd = _get_active_cwd()
    now = datetime.now().strftime("%H:%M")

    parts = []
    if cwd:
        parts.append((f" {cwd} ", RIGHT_CWD_BG, RIGHT_CWD_FG))
    parts.append((f" {now} ", RIGHT_TIME_BG, RIGHT_TIME_FG))

    # One reverse powerline separator before each segment
    total_len = sum(len(text) + 1 for text, _, _ in parts)
    start_x = max(0, screen.columns - total_len)
    screen.cursor.x = start_x

    prev_bg = as_rgb(int(to_color(TAB_BAR_BG)))
    for text, bg_hex, fg_hex in parts:
        seg_bg = as_rgb(int(to_color(bg_hex)))
        seg_fg = as_rgb(int(to_color(fg_hex)))

        # Reverse powerline separator (points left)
        screen.cursor.fg = seg_bg
        screen.cursor.bg = prev_bg
        screen.draw("\ue0b2")

        # Segment text
        screen.cursor.bg = seg_bg
        screen.cursor.fg = seg_fg
        screen.draw(text)

        prev_bg = seg_bg

    return start_x


def _redraw_tab_bar(_) -> None:
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


timer_id = None


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)

    # Draw session indicator once at the start of the tab bar (first tab only)
    if extra_data.prev_tab is None:
        _draw_session_indicator(screen, draw_data)

    # Restore cursor colors for this tab (session indicator may have overwritten them)
    tab_bg = as_rgb(draw_data.tab_bg(tab))
    tab_fg = as_rgb(draw_data.tab_fg(tab))
    screen.cursor.bg = tab_bg
    screen.cursor.fg = tab_fg

    # Draw left arrow into the first tab (draw_tab_with_powerline skips this
    # when cursor.x != 0)
    if extra_data.prev_tab is None and screen.cursor.x > 0:
        default_bg = as_rgb(int(to_color(TAB_BAR_BG)))
        screen.cursor.fg = default_bg
        screen.cursor.bg = tab_bg
        screen.draw("\ue0b0")  # 
        screen.cursor.fg = tab_fg

    before = screen.cursor.x

    label = _tab_label(tab, index)
    tab_for_draw = tab
    if label != (getattr(tab, "title", "") or ""):
        try:
            setattr(tab, "title", label)
        except Exception:
            try:
                tab_for_draw = tab._replace(title=label)
            except Exception:
                pass

    draw_tab_with_powerline(
        draw_data,
        screen,
        tab_for_draw,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )

    _draw_right_status(screen, is_last, draw_data)

    return screen.cursor.x
