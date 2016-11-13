# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-autosuggestions", nice:10
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "joel-porquet/zsh-dircolors-solarized"
zplug "jocelynmallon/zshmarks"

zplug "themes/ys", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# zplug load --verbose
zplug load

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export HISTSIZE=11000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
export EDITOR='nvim'

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

alias g="jump"
alias s="bookmark"
alias d="deletemark"
alias p="showmarks"
alias l="showmarks"

setupsolarized dircolors.ansi-light

[[ $SHLVL != "2" ]] && tmux new
