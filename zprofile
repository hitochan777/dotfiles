eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# direnv settings
eval "$(direnv hook zsh)"

export PATH="$PATH:$HOME/.dotnet/tools"

# >>> JVM installed by coursier >>>
export JAVA_HOME="/home/hitochan/.cache/coursier/arc/https/github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.25%252B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.25_9.tar.gz/jdk-11.0.25+9"
export PATH="$PATH:/home/hitochan/.cache/coursier/arc/https/github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.25%252B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.25_9.tar.gz/jdk-11.0.25+9/bin"
# <<< JVM installed by coursier <<<

# >>> coursier install directory >>>
export PATH="$PATH:/home/hitochan/.local/share/coursier/bin"
# <<< coursier install directory <<<
