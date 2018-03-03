SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

mkdir -p $HOME/.config/nvim

ln -s $SCRIPTPATH/vimrc $HOME/.vimrc
ln -s $SCRIPTPATH/vimrc $HOME/.config/nvim/init.vim
ln -s $SCRIPTPATH/dein.toml $HOME/.config/nvim/dein.toml # for nvim
ln -s $SCRIPTPATH/dein.toml $HOME/dein.toml # for vim
ln -s $SCRIPTPATH/ideavimrc $HOME/.ideavimrc
ln -s $SCRIPTPATH/latexmkrc $HOME/.latexmkrc
ln -s $SCRIPTPATH/zshrc $HOME/.zshrc
ln -s $SCRIPTPATH/tmux.conf $HOME/.tmux.conf
ln -s $SCRIPTPATH/czrc $HOME/.czrc
