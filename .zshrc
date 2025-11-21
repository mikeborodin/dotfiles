export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/fvm/default/bin"
export PATH="$PATH":"$HOME/programs/nnn/source"
export PATH="$PATH":"$HOME/scripts"
export PATH="$PATH:$HOME/programs/bin"
export PATH="$PATH:$HOME/go/bin"

export PATH="$PATH:$HOME/.android/sdk/platform-tools"
export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
export PATH="$PATH:$HOME/Library/Android/sdk/cmdline-tools/latest/bin"
export PATH="$PATH:$HOME/Library/Python/3.9/bin"
export PATH="$PATH:$HOME/Library/Android/sdk/emulator"
export PATH="$PATH":"$HOME/programs/sonar-scanner/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH":"$HOME/.maestro/bin"

export PATH="$PATH":"$HOME/personal_projects/extract/bin"
export PATH="$PATH":"$HOME/personal_projects/other/bin"
export PATH="$PATH":"$HOME/personal_projects/status/bin"
export PATH="$PATH":"$HOME/personal_projects/testui/bin"
export PATH="$PATH":"$HOME/personal_projects/buildrunnerui/bin"
export PATH="$PATH:/Users/mike/.local/bin"
export PATH="$PATH":"/Applications/Firefox.app/Contents/MacOS"
export PATH="$PATH:/opt/homebrew/bin"

export HOMEBREW_NO_AUTO_UPDATE=1

# source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
eval "$(devbox global shellenv)"
 
export PATH="$HOME/programs/neovim/out/bin:$PATH"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(zsh-autosuggestions)

# enable italics in vim
source $ZSH/oh-my-zsh.sh
ZSH_DISABLE_COMPFIX=true
# export TERM=xterm-256color

# agnostic 

export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"


# export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home'
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT=$ANDROID_HOME
alias python='python3'

source ~/aliases.sh
source ~/env.sh
source ~/personal_projects/dotfiles/prompts.sh

# export NVM_DIR="$HOME/.nvm"

# eval "$(op completion zsh)"; compdef _op op
# eval "$(fzf --zsh)"

# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.

# if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(type -w __init_nvm | awk '{print $2}')" = function ]; then
#   export NVM_DIR="$HOME/.nvm"
#   [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
#   declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
#   function __init_nvm() {
#     for i in "${__node_commands[@]}"; do unalias $i; done
#     . "$NVM_DIR"/nvm.sh
#     unset __node_commands
#     unset -f __init_nvm
#   }
#   for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
# fi

export QEMU_AUDIO_DRV=none


[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Completion scripts setup. Remove the following line to uninstall
# [[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# eval "$(tmuxifier init -)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PATH="$HOME/.shorebird/bin:$PATH"

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"
export PATROL_MIGRATED=true

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
# [[ -f /Users/mike/.dart-cli-completion/zsh-config.zsh ]] && . /Users/mike/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# export VOLTA_HOME="$HOME/.volta"
# export PATH="$VOLTA_HOME/bin:$PATH"
# Make zsh autocomplete with up arrow
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--color=fg:#c0caf5,bg:#24283b,hl:#6f76b9 \
--color=fg+:#c0caf5,bg+:#292e42,hl+:#6f76b9 \
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a \
--pointer " 


# pnpm
export PNPM_HOME="/Users/mike/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
export PATH=$PATH:$HOME/.maestro/bin
# eval "$(rbenv init - zsh)"

# bun completions
# [ -s "/Users/mike/.bun/_bun" ] && source "/Users/mike/.bun/_bun"

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

NPM_PACKAGES="${HOME}/.npm-packages"

export PATH="$PATH:$NPM_PACKAGES/bin"

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# Created by `pipx` on 2024-07-01 17:59:06
if [ -f "/Users/mike/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/mike/.config/fabric/fabric-bootstrap.inc"; fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# opencode
export PATH=/Users/mike/.opencode/bin:$PATH
