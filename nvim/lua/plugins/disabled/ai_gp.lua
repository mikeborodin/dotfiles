-- kinda good, nice context
return {
  'robitx/gp.nvim',
  enabled = false,
  config = function()
    require('gp').setup {
      openai_api_endpoint = 'http://localhost:11434/v1/chat/completions',
      chat_topic_gen_model = 'mistral',
      agents = {
        {
          name = 'Mistral',
          chat = true,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = 'mistral', temperature = 0.3, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = 'You are a general AI assistant.\n\n'
            .. 'The user provided the additional info about how they would like you to respond:\n\n'
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. '- Ask question if you need clarification to provide better answer.\n'
            .. '- Think deeply and carefully from first principles step by step.\n'
            .. '- Zoom out first to see the big picture and then zoom in to details.\n'
            .. '- Use Socratic method to improve your thinking and coding skills.\n'
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
      },
    }
  end,
}
