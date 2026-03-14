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
SESSION_BG = "#8aadf4"
SESSION_FG = "#181926"

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


def _draw_right_status(screen: Screen, is_last: bool, draw_data: DrawData) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)

    now = datetime.now().strftime("%d-%m-%Y %H:%M")
    right_text = f" {now} "
    right_status_length = len(right_text)

    screen.cursor.x = screen.columns - right_status_length

    default_bg = as_rgb(int(to_color(TAB_BAR_BG)))
    tab_fg = as_rgb(int(to_color(NORMAL_TAB_FG)))

    screen.cursor.bg = default_bg
    screen.cursor.fg = tab_fg
    screen.draw(right_text)

    return screen.cursor.x


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

    draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )

    _draw_right_status(screen, is_last, draw_data)

    return screen.cursor.x
