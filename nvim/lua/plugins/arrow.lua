return {
    "otavioschwanck/arrow.nvim",
    opts = {
        separate_by_branch = true,
        mappings = {
            edit = "E",
            delete_mode = "D",
            clear_all_items = "C",
            toggle = "S", -- used as save if separate_save_and_remove is true
            open_vertical = "V",
            open_horizontal = "-",
            quit = "q",
            remove = "x", -- only used if separate_save_and_remove is true
            next_item = "]",
            prev_item = "["
        },
        show_icons = true,
        leader_key = '<C-i>',             -- Recommended to be a single key
        index_keys = "neiohluytsradgpfw", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
    }
}
