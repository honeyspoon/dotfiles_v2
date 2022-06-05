
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


PATH="$PATH:$HOME/flutter/bin"

PATH="$PATH:$HOME/Library/Android/sdk/emulator"
PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"

ELEM_INSTALL_DIR="/Users/honeyspoon/.elementary"
PATH="$ELEM_INSTALL_DIR/bin:$PATH"

PATH=~/.local/bin:$PATH

export PATH

export STARCORE_FRAMEWORKPATH=/Users/honeyspoon/starcore_for_ios
export STARCORE_PATH=/Users/honeyspoon/starcore_for_ios

alias vi='nvim'
alias cat='bat'
alias g='git'
alias ls='exa'

source $HOME/antigen.zsh

antigen bundle mroth/evalcache
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle ael-code/zsh-colored-man-pages
antigen bundle jeffreytse/zsh-vi-mode

antigen theme romkatv/powerlevel10k
antigen apply

HISTFILE=~/.zsh_history
HISTSIZE=1000000000
HISTFILESIZE=1000000000
SAVEHIST=$HISTSIZE

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/honeyspoon/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/honeyspoon/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/honeyspoon/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/honeyspoon/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
