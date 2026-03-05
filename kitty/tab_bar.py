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

# Tab bar colors matching Wezterm config
TAB_BAR_BG = "#181926"
ACTIVE_TAB_BG = "#383d6d"
ACTIVE_TAB_FG = "#ffffff"
NORMAL_TAB_BG = "#191f26"
NORMAL_TAB_FG = "#808080"

CALENDAR_CLOCK_ICON = "󰃰 "
REFRESH_TIME = 1


def _get_datetime_cell() -> dict:
    now = datetime.now().strftime("%d-%m-%Y %H:%M")
    return {"icon": CALENDAR_CLOCK_ICON, "icon_bg_color": "#8aadf4", "text": now}


def _create_cells() -> list[dict]:
    return [_get_datetime_cell()]


def _draw_right_status(screen: Screen, is_last: bool, draw_data: DrawData) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)

    cells = _create_cells()
    right_status_length = 0
    for c in cells:
        right_status_length += 3 + len(c["icon"]) + len(c["text"])

    screen.cursor.x = screen.columns - right_status_length

    default_bg = as_rgb(int(to_color(TAB_BAR_BG)))
    tab_fg = as_rgb(int(to_color(NORMAL_TAB_FG)))

    screen.cursor.bg = default_bg
    for c in cells:
        screen.cursor.fg = tab_fg
        screen.draw(f" {c['text']} ")

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
    draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    _draw_right_status(screen, is_last, draw_data)
    return screen.cursor.x
