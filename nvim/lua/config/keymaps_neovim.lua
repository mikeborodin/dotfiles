require("utils.find_replace")
require("utils.common_utils")
require("utils.go_to_test")
require("utils.run_script")


local keys = {
  --selected
  { 'tk',             require('telescope.builtin').keymaps,                                            '?' },
  -- { 'tf',             '<cmd>Neotree focus<cr>',                                                        '?' },
  --space
  -- { '<space>su',      '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<cr>',       'Next diagnos' },
  { '<space>sn',      function() require("trouble").previous({ skip_groups = true, jump = true }) end, 'Prev diagnos' },
  { '<space>ff',      require('telescope.builtin').current_buffer_fuzzy_find,                          'Find in buff' },
  { '<space>fw',      require('telescope.builtin').live_grep,                                          'Live grep' },
  { '<space>fr',      ':lua find_replace_prompt()<cr>',                                                'File find/rep' },
  { '<space><space>', function() vim.lsp.buf.format() end,                                             'Format' },
  -- { '<space>h',       function() vim.lsp.buf.hover() end,                                              'Format' },
  { '<space>h',       function() require('hover').hover() end,                                         'Format' },
  { '<space>H',       function() vim.diagnostic.open_float() end,                                      'Floating diagnos' },
  { '<space>ni',      require('telescope.builtin').lsp_implementations,                                'Impl' },
  { '<space>no',      require('telescope.builtin').lsp_references,                                     'Reference' },
  { '<C-e>',          function() require('telescope.builtin').find_files({ hidden = true }) end,       '?' },
  { 'af',             require('telescope.builtin').live_grep,                                          'Live grep' },
  { 'tFs',            require('telescope.builtin').lsp_workspace_symbols,                              'Find symbol' },
  { 'tr',             function() vim.lsp.buf.rename() end,                                             'Rename' },
  --
  --windows
  { 'tya',            '<cmd>%bdelete<cr><cmd>lua require("neo-tree").focus()<cr>',                     'Close all buffers' },
  { '<C-y>',          ':Bdelete<cr>',                                                                  'Close buffer' },
  { '<space>y',       ':Bdelete<cr>',                                                                  'Close buffer' },
  --running
  { 'ab',             require('telescope.builtin').buffers,                                            'Buffers' },
  { 'ah',             require('telescope.builtin').diagnostics,                                        'Find diagnost' },
  { 'sn',             '<cmd>FlutterRun<cr>',                                                           'Flutter Run' },
  { '<space>sn',      '<cmd>FlutterRun<cr>',                                                           'Flutter Restart' },
  { 'se',             '<cmd>FlutterRestart<cr>',                                                       'Flutter Restart' },
  { '<space>se',      '<cmd>FlutterRestart<cr>',                                                       'Flutter Restart' },
  { 'sy',             '<cmd>FlutterQuit<cr>',                                                          'Flutter Quit' },
  { '<space>sy',      '<cmd>FlutterQuit<cr>',                                                          'Flutter Quit' },
  { 'ss',             '<cmd>Telescope flutter commands<cr>',                                           'Find fluttercmd' },
  { '<space>sk',      '<cmd>FlutterLogClear<cr>',                                                      'Flutter Quit' },
  { '<space>kn',      '<cmd>FlutterLogClear<cr>',                                                      'Flutter Quit' },
  --debugging
  { '<space>sr',      '<cmd>TroubleToggle workspace_diagnostics<cr>',                                  'Toggle diagnst.' },
  { 'su',             '<cmd>DapContinue<cr>',                                                          'DapContinue' },
  { 'st',             '<cmd>DapToggleBreakpoint<cr>',                                                  'Toggle breakpnt' },
  { 'sh',             function() require('dapui').toggle() end,                                        'Toggle DapUI' },
  --testing
  { 'tso',            jumpToTest,                                                                      'Jump to test' },
  -- { '<space>tf',      function() require("neotest").run.run({ strategy = 'dap' }) end,                 'Run this test' },
  -- { '<space>tw',      '<cmd>lua  require("neotest").run.run(vim.fn.expand("%"))<cr>',                  'Run test file' },
  -- :Coverage && CoverageToggle
  { '<space>U',       '<Cmd>call copilot#Complete()<CR>',                                              'copilot complete' },
  { '<Space>e',       function() vim.lsp.buf.code_action() end,                                        'Code action (visual)' },
  { '<Space>rs',      function() RunProjectScript() end,                                               'Run project script' },
  { 'at',             ':FlutterRun<cr>',                                                               'FlutterRun' },
}

useKeymapTable(keys)
