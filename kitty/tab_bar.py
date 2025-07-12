"""draw kitty tab"""
# pyright: reportMissingImports=false
# pylint: disable=E0401,C0116,C0103,W0603,R0913

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_title,
)
from kitty.utils import color_as_int

opts = get_options()

# colors
# MAGENTA_1 = as_rgb(color_as_int(opts.color5))

TABBAR_BG = as_rgb(color_as_int(opts.tab_bar_background or opts.color0))

ACTIVE_BG = as_rgb(color_as_int(opts.active_tab_background or opts.color8))
ACTIVE_FG = as_rgb(color_as_int(opts.active_tab_foreground or opts.color4))
INACTIVE_BG = as_rgb(color_as_int(
    opts.inactive_tab_background or opts.color12))
INACTIVE_FG = as_rgb(color_as_int(opts.inactive_tab_foreground or opts.color7))

ACTIVE_WINDOW_BG = as_rgb(color_as_int(opts.color6))


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

    _draw_left_status(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )

    if is_last:
        _draw_right_status(screen)

    return screen.cursor.x


def _draw_right_status(screen: Screen) -> int:

    tab_manager = get_boss().active_tab_manager
    cells = []
    LOWER_RIGHT_TRIANGLE = ''
    FORWARD_SLASH = ''

    if tab_manager is not None:
        windows = tab_manager.active_tab.windows.all_windows
        if windows is not None:
            for i, window in enumerate(windows):
                is_active = window.id == tab_manager.active_window.id
                is_first = i == 0
                is_prev_active = windows[i -
                                         1].id == tab_manager.active_window.id if not is_first else False

                sup = to_sup(str(i + 1))

                window_fg = ACTIVE_FG if is_active else INACTIVE_FG
                window_bg = ACTIVE_WINDOW_BG if is_active else INACTIVE_BG

                if is_first:
                    sep = LOWER_RIGHT_TRIANGLE
                    sep_bg = TABBAR_BG
                    sep_fg = INACTIVE_BG if not is_active else ACTIVE_WINDOW_BG
                elif is_active:
                    sep = LOWER_RIGHT_TRIANGLE
                    sep_bg = INACTIVE_BG
                    sep_fg = ACTIVE_WINDOW_BG
                elif is_prev_active:
                    sep = LOWER_RIGHT_TRIANGLE
                    sep_bg = ACTIVE_WINDOW_BG
                    sep_fg = INACTIVE_BG
                else:
                    sep = FORWARD_SLASH
                    sep_bg = INACTIVE_BG
                    sep_fg = INACTIVE_FG

                cells.insert(
                    i*2, (window_fg, window_bg, f" {sup} {window.title} "))
                cells.insert(
                    i*2, (sep_fg, sep_bg, sep))

    # calculate leading spaces to separate tabs from right status
    right_status_length = 0
    for _, _, cell in cells:
        right_status_length += len(cell)

    # calculate leading spaces
    leading_spaces = 0
    leading_spaces = screen.columns - screen.cursor.x - right_status_length

    # draw leading spaces
    if leading_spaces > 0:
        screen.draw(" " * leading_spaces)

    # draw right status
    for fg, bg, cell in cells:
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(cell)
    screen.cursor.fg = 0
    screen.cursor.bg = 0

    # update cursor position
    screen.cursor.x = max(
        screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x


SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ("", "")
ICON = "  "


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # if screen.cursor.x >= screen.columns - right_status_length:
    #     return screen.cursor.x
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False
    # if screen.cursor.x <= len(ICON):
    #     screen.cursor.x = len(ICON)
    # screen.draw(" ")
    screen.cursor.bg = tab_bg
    draw_title(draw_data, screen, tab, index)
    if not needs_soft_separator:
        screen.draw(" ")
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(SEPARATOR_SYMBOL)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.cursor.fg = prev_fg  # separator_fg
        screen.draw(" " + SOFT_SEPARATOR_SYMBOL)
    end = screen.cursor.x
    return end


def to_sup(s):
    sups = {u'0': u'\u2070',
            u'1': u'\xb9',
            u'2': u'\xb2',
            u'3': u'\xb3',
            u'4': u'\u2074',
            u'5': u'\u2075',
            u'6': u'\u2076',
            u'7': u'\u2077',
            u'8': u'\u2078',
            u'9': u'\u2079'}

    return ''.join(sups.get(char, char) for char in s)
