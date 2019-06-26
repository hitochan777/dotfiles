bindkey -e

unameOut=$(uname -s)
case "${unameOut}" in
  Linux*)   machine=Linux;;
  Darwin*)  machine=Mac;;
  *)        machine="UNKNOWN:${unameOut}"
esac

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Check if zplug is installed
if [[ ! -d ${ZDOTDIR:-$HOME}/.zprezto ]]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
fi

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# zplug "zsh-users/zsh-syntax-highlighting", defer:2
# zplug "zsh-users/zsh-history-substring-search", defer:3
# zplug "jocelynmallon/zshmarks"
# zplug "jimeh/zsh-peco-history", defer:2
# zplug "b4b4r07/enhancd", use:init.sh

if [ "${machine}" = "Mac" ]
then
  UPKEY='\e[A'
  DOWNKEY='\e[B'
else
  UPKEY="^[OA"
  DOWNKEY="^[OB"
fi

bindkey "$UPKEY" history-substring-search-up
bindkey "$DOWNKEY" history-substring-search-down

# golang
export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"

### CONFIG ###
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

export HISTSIZE=11000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
export EDITOR='nvim'

# zshmark
alias g="jump"
alias ss="bookmark"
alias d="deletemark"
alias l="showmarks"
# yarn
alias yb="yarn build"
alias yt="yarn test"
alias yc="yarn clean"
# use nvim for vim (only necessary in mac)
alias vim=nvim
export PATH=$HOME/tools/nvim/bin:$PATH

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init - zsh)"

# pipenv
alias ppr="pipenv run"
eval "$(pipenv --completion)"

# misc
alias ls="ls --color"
export PATH="$HOME/.local/bin:$HOME/local/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin

export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"
export LIBRARY_PATH="$HOME/local/lib:$LIBRARY_PATH"
export CPLUS_INCLUDE_PATH="$HOME/local/include:$CPLUS_INCLUDE_PATH"
export C_INCLUDE_PATH="$HOME/local/include:$C_INCLUDE_PATH"

# nim
export PATH=$PATH:$HOME/.nimble/bin:$HOME/tools/nim/bin

# meteor
export PATH="$HOME/.meteor":$PATH

# n
export N_PREFIX=$HOME/.local

# npm
export PATH=$HOME/.npm-global/bin:$HOME/.yarn/bin:$PATH

# direnv settings
eval "$(direnv hook zsh)"

# ts-node
export TS_NODE_TYPE_CHECK=true

############  Google Cloud SDK settings ##############
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/tools/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/tools/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
######################################################
if [ -f "$HOME/tools/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/tools/google-cloud-sdk/completion.zsh.inc"; fi
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# you need this for ls to properly work in mac
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# enhanced {{{
export ENHANCD_FILTER=peco:fzf
export ENHANCD_DISABLE_DOT=1
# }}}

# peco {{{
function peco-history-selection() {
    BUFFER=`history -n 1 | tac | awk '!a[$0]++' | peco --layout=top-down --initial-filter=Fuzzy` 
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
# }}}
