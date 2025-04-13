---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  commit = '8418e7028f91feacffcf75236fd4e93a5a3fe911',
  dependencies = {
    -- check the installation instructions at
    -- https://github.com/folke/snacks.nvim
    "folke/snacks.nvim"
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<space>fm",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Reveal yazi",
    },
    {
      "tf",
      mode = { "n", "v" },
      "<cmd>Yazi toggle<cr>",
      desc = "Last yazi",
    },
  },
  ---@type YaziConfig | {}
  opts = {
    open_for_directories = false,
    floating_window_scaling_factor = 0.9,
    keymaps = {
      keymaps = {
        show_help = "?",
        open_file_in_vertical_split = "os",
        open_file_in_horizontal_split = "oS",
        -- open_file_in_tab = "<c-t>",
        grep_in_directory = "<c-s>",
        replace_in_directory = "<c-g>",
        -- cycle_open_buffers = "<tab>",
        copy_relative_path_to_selected_files = "W",
        send_to_quickfix_list = "<c-q>",
        change_working_directory = "<c-\\>",
      },
    },
  },
}
