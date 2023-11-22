return {
  'David-Kunz/gen.nvim',
  keys = {
    { '<space>an', ':Gen fix<cr>',      mode = { 'n', 'v', }, desc = 'AI Fix' },
    { '<space>ar', ':Gen refactor<cr>', mode = { 'n', 'v', }, desc = 'AI Refactor' },
    { '<space>aw', ':Gen reword<cr>',   mode = { 'n', 'v', }, desc = 'AI Reword' },
  },
  config = function()
    require('gen').prompts['reword'] = {
      prompt = "Elaborate the following text and improve the grammar:\n$text",
      replace = true
    }
    require('gen').prompts['fix'] = {
      prompt =
      "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
      replace = true,
      extract = "```$filetype\n(.-)```"
    }
    require('gen').prompts['refactor'] = {
      prompt =
      "Refactor the following code to. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
      replace = true,
      extract = "```$filetype\n(.-)```"
    }
  end,

}
