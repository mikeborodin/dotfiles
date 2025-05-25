alias dr = devbox run
alias drs = devbox run shell

alias v = nvim
alias e = exit
alias y = yazi
alias gg = lazygit
alias python = python3
alias ai = aichat -S
alias aio = aichat -S -m ollama:llama3.1

def dif [name:string = 'main'] {
    (
    git diff --name-only main 
        | lines 
        | where { |it| 
            not (($it | str contains "localization_") or ($it | str contains "i18n") or ($it | str contains ".g.dart") or ($it | str contains ".freezed.dart"))  
        } 
        | str join "\n" 
        | fzf --preview=$"git diff ($name) --color=always -- {-1} | delta "  --preview-window='right:60%,border-none' --ansi --reverse
        --multi --bind 'enter:become(nvim {+})'
    )
}
