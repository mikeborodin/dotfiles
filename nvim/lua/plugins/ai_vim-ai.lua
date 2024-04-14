
vim.cmd [[
let s:initial_chat_prompt =<< trim END
>>> system

You are a general assistant.
If you attach a code block add syntax type after ``` to enable syntax highlighting.
END
let g:vim_ai_chat = {
\  "options": {
\    "model": "mistral",
\    "endpoint_url": "http://localhost:11434/v1/chat/completions",
\    "max_tokens": 1000,
\    "temperature": 0.2,
\    "request_timeout": 10,
\    "enable_auth": 0,
\    "selection_boundary": "",
\    "initial_prompt": s:initial_chat_prompt,
\  },
\}
]]

vim.cmd [[
let s:initial_chat_prompt =<< trim END
>>> system

You are a general assistant.
If you attach a code block add syntax type after ``` to enable syntax highlighting.
END
let g:vim_ai_edit = {
\  "engine": "complete",
\  "options": {
\    "model": "mistral",
\    "endpoint_url": "http://localhost:11434/v1/completions",
\    "max_tokens": 1000,
\    "temperature": 0.2,
\    "request_timeout": 20,
\    "enable_auth": 0,
\    "selection_boundary": "",
\    "initial_prompt": s:initial_chat_prompt,
\  },
\  "ui": {
\    "paste_mode": 1,
\  },
\}
]]

vim.cmd [[
let s:initial_chat_prompt =<< trim END
>>> system

You are a general assistant.
If you attach a code block add syntax type after ``` to enable syntax highlighting.
END
let g:vim_ai_complete = {
\  "engine": "complete",
\  "options": {
\    "model": "mistral",
\    "endpoint_url": "http://localhost:11434/v1/completions",
\    "max_tokens": 1000,
\    "temperature": 0.1,
\    "request_timeout": 20,
\    "enable_auth": 0,
\    "selection_boundary": "#####",
\    "initial_prompt": s:initial_chat_prompt,
\  },
\  "ui": {
\    "paste_mode": 1,
\  },
\}
]]

return {
    'madox2/vim-ai',
    enabled = false,
}
