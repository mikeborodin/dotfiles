return {
  'David-Kunz/gen.nvim',
  enabled = false,
  opts = {
    model = 'llama3.1', -- The default model to use.
    host = 'localhost', -- The host running the Ollama service.
    port = '11434', -- The port on which the Ollama service is listening.
    quit_map = 'q', -- set keymap for close the response window
    retry_map = 'r', -- set keymap to re-send the current prompt
    debug = false,
    display_mode = 'float', -- The display mode. Can be "float" or "split".
    show_prompt = false, -- Shows the Prompt submitted to Ollama.
    show_model = false, -- Displays which model you are using at the beginning of your chat session.
    no_auto_close = false, -- Never closes the window automatically.
  },
  config = function()
    require('gen').prompts['Implement'] = {
      prompt = 'write just enough implementation to pass following Dart tests: ```$filetype\n$text\n```',
      replace = false,
      extract = '```$filetype\n(.-)```',
    }
    require('gen').prompts['Update replacing'] = {
      prompt = 'Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```. Your task task is: $input\n',
      replace = true,
      extract = '```$filetype\n(.-)```',
    }
    require('gen').prompts['Update'] = {
      prompt = 'update the following code ```$filetype\n$text\n``` returning the result in format ```$filetype\n...\n```. Your task task is: $input\n',
      replace = false,
      extract = '```$filetype\n(.-)```',
    }
    require('gen').prompts['Convert'] = {
      prompt = 'MY SELECTED TEXT: ```$filetype\n$text\n```. Provide the output in format ```$filetype\n...\n```, your task is: $input\n',
      replace = false,
      extract = '```$filetype\n(.-)```',
    }
    require('gen').prompts['reword'] = {
      prompt = 'Elaborate the following text and improve the grammar:\n$text',
      replace = true,
    }
    require('gen').prompts['fix'] = {
      prompt = 'Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```',
      replace = true,
      extract = '```$filetype\n(.-)```',
    }
    require('gen').prompts['refactor'] = {
      prompt = 'Refactor the following code to. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```',
      replace = true,
      extract = '```$filetype\n(.-)```',
    }
  end,
}
-- create vim.g.genContext using the whole project directory
-- vim.g.genTree = vim.fn.system('tree')
-- print(vim.g.genTree)
--
-- vim.g.genArrowFileContents = ''
-- local filesList = vim.g.arrow_filenames
-- for _, fileName in ipairs(filesList) do
--   local fileContent = vim.fn.system('cat ' .. fileName)
--   vim.g.genArrowFileContents = vim.g.genArrowFileContents ..
--       '`' .. fileName .. '`:\n' ..
--       '```' .. 'dart' .. '\n'
--       .. fileContent .. '```\n'
-- end
--
-- print(vim.g.genArrowFileContents)

-- "I work on Dart project described below " ..
-- "PROJECT STRUCTURE:" ..
-- vim.g.genTree ..
-- "CONTENTS OF RELEVANT FILES:" ..
-- vim.g.genArrowFileContents ..
