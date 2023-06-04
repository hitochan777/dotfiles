SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

mkdir -p $HOME/.config/nvim

ln -s $SCRIPTPATH/init.lua $HOME/.config/nvim/init.lua
ln -s $SCRIPTPATH/ideavimrc $HOME/.ideavimrc
ln -s $SCRIPTPATH/latexmkrc $HOME/.latexmkrc
ln -s $SCRIPTPATH/zshrc $HOME/.zshrc
ln -s $SCRIPTPATH/zprofile $HOME/.zprofile
ln -s $SCRIPTPATH/tmux.conf $HOME/.tmux.conf
ln -s $SCRIPTPATH/czrc $HOME/.czrc
ln -s $SCRIPTPATH/gitconfig $HOME/.gitconfig
ln -s $SCRIPTPATH/nvim $HOME/.config/
ln -s $SCRIPTPATH/nvchad/custom $HOME/.config/nvim/lua/

