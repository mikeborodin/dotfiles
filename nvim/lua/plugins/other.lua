return {
  'rgroli/other.nvim',
  config = function()
    require('other-nvim').setup {
      rememberBuffers = false,
      mappings = {
        -- screen controller
        {
          pattern = '/lib/(.*)/(.*)_screen.dart$',
          target = {
            {
              target = '/lib/%1/%2_controller.dart',
              context = 'Controller',
            },
          },
        },
        {
          pattern = '/lib/(.*)/(.*)_controller.dart$',
          target = {
            {
              target = '/lib/%1/%2_screen.dart',
              context = 'Screen',
            },
          },
        },
        -- test implementation
        {
          pattern = '/lib/(.*)/(.*).dart$',
          target = {
            {
              target = '/test/%1/%2_test.dart',
              context = 'test',
            },
          },
        },
        {
          pattern = '/lib/(.*).dart$',
          target = {
            {
              target = '/test/%1_test.dart',
              context = 'test',
            },
          },
        },
        {
          pattern = '/test/(.*)/(.*)_test.dart$',
          target = {
            {
              target = '/lib/%1/%2.dart',
              context = 'subject',
            },
          },
        },
        {
          pattern = '/test/(.*)_test.dart$',
          target = {
            {
              target = '/lib/%1.dart',
              context = 'subject',
            },
          },
        },
      },
      transformers = {
        -- defining a custom transformer
        -- lowercase = function (inputString)
        --     return inputString:lower()
        -- end
      },
      style = {
        -- How the plugin paints its window borders
        -- Allowed values are none, single, double, rounded, solid and shadow
        border = 'rounded',

        -- Column seperator for the window
        seperator = '|',

        newFileIndicator = '(* new *)',
        -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
        width = 0.7,

        -- min height in rows.
        -- when more columns are needed this value is extended automatically
        minHeight = 2,
      },
    }
  end,
}
