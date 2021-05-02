eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init - zsh)"

# pipenv
alias ppr="pipenv run"
eval "$(pipenv --completion)"

# direnv settings
eval "$(direnv hook zsh)"

export PATH="$PATH:$HOME/.dotnet/tools"
