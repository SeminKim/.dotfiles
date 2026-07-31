#! /bin/bash

#==================================================#
# argument parser
# usage : https://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash
while getopts 'cfu:' flag; do
  case "${flag}" in
    f) forced='true' ;;
    u) update="${OPTARG}" ;;
  esac
done


#==================================================#
DOT_DIR=$PWD
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$ZSH/custom


#==================================================#
source "$PWD/aliases/misc"
if [ "$forced" != "true" ]; then
    buo .Xmodmap .vim .vimrc .tmux.conf .aliases .gitconfig .gitconfig.secret .zshrc .oh-my-zsh .fzf
fi
ln -sf $DOT_DIR/Xmodmap $HOME/.Xmodmap # key mapping 
ln -sf $DOT_DIR/vimrc $HOME/.vimrc # vim confnigs
ln -sf $DOT_DIR/tmux.conf $HOME/.tmux.conf # tmux configs
ln -sf $DOT_DIR/aliases $HOME/.aliases # zsh aliases
ln -sf $DOT_DIR/gitconfig $HOME/.gitconfig # git configs
ln -sf $DOT_DIR/zshrc $HOME/.zshrc # zsh configs
echo; echo '** download oh-my-zsh.'
bash $DOT_DIR/install-omz.sh; 
# ln -sf $DOT_DIR/themes/mrtazz_custom.zsh-theme $HOME/.oh-my-zsh/themes/


#==================================================#
# download useful plugins

# zsh
echo; echo '** download zsh plugins.'
## zsh-syntax-highlighting 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting
## zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions
## fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all
## zsh theme
git clone --branch v3.16.7 https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
## zsh theme fix
rm $HOME/.oh-my-zsh/custom/themes/spaceship-prompt/lib/section.zsh
ln -sf $DOT_DIR/fixes/section.zsh $HOME/.oh-my-zsh/custom/themes/spaceship-prompt/lib/
cp $DOT_DIR/fixes/cuda.zsh $HOME/.oh-my-zsh/custom/themes/spaceship-prompt/sections/


# vim 
echo; echo '** download vim plugins.'
## colorschemes
mkdir $HOME/.vim
git clone https://github.com/flazz/vim-colorschemes.git $HOME/.vim
## vim plugin
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
## pathogen: vim plugins manager
mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle && curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
## nerdtree: file/directory browser
git clone https://github.com/scrooloose/nerdtree.git $HOME/.vim/bundle/nerdtree
## jedi-vim: jumps, auto-suggestions/completions
git clone --recursive https://github.com/davidhalter/jedi-vim.git $HOME/.vim/bundle/jedi-vim
## airline: status/tabline customization
git clone https://github.com/vim-airline/vim-airline $HOME/.vim/bundle/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes $HOME/.vim/bundle/vim-airline-themes
## vim-flake8 : pep8 checker
git clone https://github.com/nvie/vim-flake8.git $HOME/.vim/bundle/vim-flake8
## vim-commentary
mkdir -p $HOME/.vim/pack/tpope/start
git clone https://tpope.io/vim/commentary.git $HOME/.vim/pack/tpope/start/commentary
vim -u NONE -c "helptags commentary/doc" -c q
## ctrlp.vim
git clone https://github.com/ctrlpvim/ctrlp.vim.git $HOME/.vim/bundle/ctrlp.vim
vim -u NONE -c "helptags $HOME/.vim/bundle/ctrlp.vim/doc" -c q
## supertab
git clone --depth=1 https://github.com/ervandew/supertab.git $HOME/.vim/pack/plugins/start/supertab
# install vim plugins
vim +'PlugInstall --sync' +qa
# custom vim color settings
rm $HOME/.vim/plugged/sonokai/colors/sonokai.vim
cp $DOT_DIR/fixes/sonokai.vim $HOME/.vim/plugged/sonokai/colors/

#==================================================#
# jupyterlab configs
pip show jupyter 1>/dev/null
if [ $? == 0 ]; then
    if ! [ -d "$HOME/.jupyter" ]; then
        mkdir "$HOME/.jupyter"
    fi
    pip install theme-darcula
    pip install jupyterlab-lsp
    pip install flake8 importlib-metadata --upgrade
    pip install 'python-lsp-server[all]'
    pip install git+https://github.com/krassowski/python-language-server.git@main
    if ! [ -d "$HOME/.jupyter/lab" ]; then
        mkdir $HOME/.jupyter/lab
    fi
    if ! [ -d "$HOME/.jupyter/lab/user-settings" ]; then
        mkdir $HOME/.jupyter/lab/user-settings
    fi
    cp -r $DOT_DIR/jupyterlab_configs/* $HOME/.jupyter/lab/user-settings
fi

#==================================================#
# set zsh to the default shell
echo; echo '** set ZSH as default shell.'
if [ "$SHELL" != "$(command -v zsh)" ]; then
    chsh -s "$(command -v zsh)"
fi
exec zsh
