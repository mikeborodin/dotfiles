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
export TERM=xterm-256color

# agnostic 
export PATH="$PATH:$HOME/fvm/default/bin"
export PATH="$PATH":"$HOME/programs/nnn/source"
export PATH="$PATH:$HOME/.tmux/tmuxifier/bin"
export PATH="$PATH":"$HOME/scripts"
export PATH="$PATH:$HOME/programs/bin"

export PATH="$PATH:$HOME/.android/sdk/platform-tools"
export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
export PATH="$PATH:$HOME/Library/Android/sdk/cmdline-tools/latest/bin"
export PATH="$PATH:$HOME/Library/Python/3.9/bin"
export PATH="$PATH:$HOME/Library/Android/sdk/emulator"
export PATH="$PATH":"$HOME/programs/sonar-scanner/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"

export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH":"/Applications/Firefox.app/Contents/MacOS"

export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home'
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT=$ANDROID_HOME
alias python='python3'

source ~/aliases.sh
source ~/env.sh

export NVM_DIR="$HOME/.nvm"

# get the name of the branch we are on
# uncomment if something breaks
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export QEMU_AUDIO_DRV=none


# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Completion scripts setup. Remove the following line to uninstall
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# eval "$(tmuxifier init -)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PATH="$HOME/.shorebird/bin:$PATH"

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"
export PATROL_MIGRATED=true

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/mike/.dart-cli-completion/zsh-config.zsh ]] && . /Users/mike/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
# Make zsh autocomplete with up arrow
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# pnpm
export PNPM_HOME="/Users/mike/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
