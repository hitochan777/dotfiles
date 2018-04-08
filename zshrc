bindkey -e

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

zplug "themes/ys", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# zplug load --verbose
zplug load

bindkey "^[OA" history-substring-search-up
bindkey "^[OB" history-substring-search-down

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

alias g="jump"
alias ss="bookmark"
alias d="deletemark"
alias l="showmarks"
alias ls="ls --color"
alias yb="yarn build"
alias yt="yarn test"
alias yc="yarn clean"

export PATH="/home/hitochan/.cargo/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin

export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"
export LIBRARY_PATH="$HOME/local/lib:$LIBRARY_PATH"
export CPLUS_INCLUDE_PATH="$HOME/local/include:$CPLUS_INCLUDE_PATH"
export C_INCLUDE_PATH="$HOME/local/include:$C_INCLUDE_PATH"

# nim
export PATH=$PATH:$HOME/.nimble/bin:$HOME/tools/nim/bin

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# meteor
export PATH="$HOME/.meteor":$PATH

# n
export N_PREFIX=$HOME/.local

# npm
export PATH=$HOME/.npm-global/bin:$PATH

# direnv settings
eval "$(direnv hook zsh)"

# ts-node
export TS_NODE_TYPE_CHECK=true

############  Google Cloud SDK settings ##############
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/hitochan/tools/google-cloud-sdk/path.zsh.inc' ]; then source '/home/hitochan/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
######################################################
if [ -f '/home/hitochan/tools/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/hitochan/tools/google-cloud-sdk/completion.zsh.inc'; fi
