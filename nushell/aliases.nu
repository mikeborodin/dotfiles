alias dr = devbox run
alias drs = devbox run shell

alias v = nvim

alias e = exit
alias y = yazi
alias gg = lazygit
alias python = python3
alias ai = aichat -S
alias drd = devbox run shell
alias aio = aichat -S -m ollama:llama3.1
alias tailscale = /Applications/Tailscale.app/Contents/MacOS/Tailscale

alias python = python3

def ll [] { ls | sort-by type }

def swd [] {
  ls -s ~/projects | get name | to text | fzf | kitten @ action launch --type=tab --cwd=$"/Users/mike/projects/($in)"
}

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
