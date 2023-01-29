bindkey -e

# zsh-peco-history {{{
export ZSH_PECO_HISTORY_OPTS="--layout=top-down --initial-filter=Fuzzy"
# https://github.com/jimeh/zsh-peco-history#zsh_peco_history_dedup
export ZSH_PECO_HISTORY_DEDUP=1
# }}}

unameOut=$(uname -s)
case "${unameOut}" in
  Linux*)   machine=Linux;;
  Darwin*)  machine=Mac;;
  *)        machine="UNKNOWN:${unameOut}"
esac

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-autosuggestions", defer:0
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "jocelynmallon/zshmarks"
zplug "jimeh/zsh-peco-history", defer:2
zplug "b4b4r07/enhancd", use:init.sh
# zplug "themes/frisk", from:oh-my-zsh
zplug "themes/ys", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# zplug load --verbose
zplug load

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

# misc
export LS_COLORS=$LS_COLORS:'di=1;35:'
alias ls="exa --icons"
export PATH="$HOME/.local/bin:$HOME/local/bin:$PATH"
export PATH=/snap/bin:/usr/local/go/bin:$PATH

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


############  Google Cloud SDK settings ##############
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/tools/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/tools/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
######################################################
if [ -f "$HOME/tools/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/tools/google-cloud-sdk/completion.zsh.inc"; fi
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

alias copy="xclip -sel clipboard"

# deno
export PATH=$HOME/.deno/bin:$PATH

# rust
export PATH=$HOME/.cargo/bin:$PATH

# kubectl settings
# source <(kubectl completion zsh)
# alias k="kubectl"

# you need this for ls to properly work in mac
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# enhanced {{{
export ENHANCD_FILTER=peco:fzf
export ENHANCD_HYPHEN_NUM=50
# export ENHANCD_DISABLE_DOT=1
# }}}

# exa {{{
alias el="exa"
# }}}

# dotnet {{{
export PATH=$HOME/.dotnet/tools:$PATH
# }}}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

. /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# pnpm
export PNPM_HOME="/home/hitochan/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
# bun completions
[ -s "/home/hitochan/.bun/_bun" ] && source "/home/hitochan/.bun/_bun"

# bun
export BUN_INSTALL="/home/hitochan/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
