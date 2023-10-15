#!/bin/bash

if [ "$UID" != "0" ] ; then
	echo
	echo "This script must be run as root"
	echo
	exit
fi

REAL_USER_NAME=`logname`

if [ "$REAL_USER_NAME" == ""  ] ; then
	REAL_USER_NAME="$1"
fi

if [ "$REAL_USER_NAME" == ""  ] ; then
	echo
	echo "ERROR: Can not find out your real username, please give your real username as the first argument for the script." 
	echo
	exit
fi

HOME_DIRECTORY=`getent passwd $REAL_USER_NAME | cut -d: -f6`

if [ "$HOME_DIRECTORY" == "" ] ; then
	echo
	echo "ERROR: Can not find out the path to the home directory of: '"$REAL_USER_NAME"', can not continue."
	echo
	exit
fi

if [ ! -e "$HOME_DIRECTORY" ] ; then
	echo
	echo "ERROR: Your home directory: "$HOME_DIRECTORY" does not exist, can not continue."
	echo
	exit
fi


# Get the path to this script
FULL_PATH_TO_SCRIPT=$(readlink -f $0)
PATH_TO_SCRIPT_DIR=`dirname $FULL_PATH_TO_SCRIPT`
PATH_TO_MODIFIED_COLOR_SCHEMES_DIR="$PATH_TO_SCRIPT_DIR/modified_colorschemes"

if [ ! -e "$PATH_TO_MODIFIED_COLOR_SCHEMES_DIR" ] ; then
        echo
        echo "ERROR: Directory for the modified color schemes: "$PATH_TO_MODIFIED_COLOR_SCHEMES_DIR" does not exist, can not continue."
        echo
        exit
fi

if [ ! -e "$PATH_TO_SCRIPT_DIR/" ] ; then
        echo
        echo "ERROR: Your home directory: "$HOME_DIRECTORY" does not exist, can not continue."
        echo
        exit
fi



# Start intallation
echo
echo "This program will do the following things:"
echo
echo "- Uninstall previous vim packages and old vim configuration. Compile and install a new vim with Python3 support."
echo "- Download and install 256 color Terminus font ."
echo "- Install vim plugins Pathogen and Tagbar plugins to make vim a Python3 IDE."
echo "- Remove most color schemes that comes with vim, leaving only: default, desert, murphy and slate."
echo "- Install 256 color vim color schemes: desert256, distinguished, jellybeans."
echo "- Sets colorscheme desert256 as default."
echo
echo "If you don't want this then press ctrl + c now."
echo
read -p "Press [Enter] key to start.."
echo



# Remove previous vim installations and install dependencies
echo "Removing apt vim packages..."
echo "--------------------------------------------------------------------------------"
apt-get -y purge vim vim-addon-manager vim-common vim-tiny vim-runtime vim-nox
VIM_PATH=`which vim`
if [ -e "$VIM_PATH" ] ; then rm -rf "$VIM_PATH" ; fi
echo
echo "Removing old vim config files..."
echo "--------------------------------------------------------------------------------"
rm -rf /usr/share/vim*
rm -rf "$REAL_USER_NAME/.vim*"
rm -rf "$REAL_USER_NAME/vim*"
echo
echo "Installing dependencies with apt-get ..."
echo "--------------------------------------------------------------------------------"
apt-get -y install git python3 python3-dev libncurses5-dev build-essential xfonts-terminus wget autoconf pkg-config
if [ "$?" != "0" ] ; then echo "Error trying to install vim dependencies" ; exit ; fi



# Compile and install vim.
NUMBER_OF_CORES=`cat /proc/cpuinfo | grep -i processor | grep ': [0-9][0-9][0-9]\|[0-9][0-9]\|[0-9]' | wc -l`
echo
echo "Cloning Vim git repository..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
rm -rf vim
# The option --depth 1 only clones the latest commit from the repo resulting in downloading only about 10% of the repo and faster download.
git clone --depth 1 https://github.com/vim/vim.git
if [ "$?" != "0" ] ; then echo "Error downloading vim source from git repository" ; exit ; fi
cd vim
git pull
cd src
./configure --with-features=normal --enable-python3interp --enable-multibyte --disable-gui --prefix=/usr
echo
echo "Compiling Vim using "$NUMBER_OF_CORES" processor cores..."
echo "--------------------------------------------------------------------------------"
make -j$NUMBER_OF_CORES
if [ "$?" != "0" ] ; then echo "Error compiling vim" ; exit ; fi
make install
if [ "$?" != "0" ] ; then echo "Error trying to install vim" ; exit ; fi
cd $HOME_DIRECTORY
rm -rf vim



# Get the version number of Vim
VIM_OUTPUT=`vim --version | awk '{ print $5 ; exit  }'`
VIM_TEMP=`echo $VIM_OUTPUT | sed 's/\.//'`
VIM_VERSION="vim"$VIM_TEMP
echo
echo "The version number of Vim is "$VIM_OUTPUT
echo "--------------------------------------------------------------------------------"



# Remove forced default indentation settings from Vim filetype plugins
echo
echo "Removing forced default indentation settings from Vim filetype plugins ..."
echo "--------------------------------------------------------------------------------"
for OLD_PATH in /usr/share/vim/$VIM_VERSION/ftplugin/*
do
	# Exclude file gitcommit.vim and leave it as it is
        FILENAME=$( basename $OLD_PATH )

        if [ "$FILENAME" == "gitcommit.vim" ] ; then
                continue
        fi

	NEW_PATH="$OLD_PATH".orig
	mv "$OLD_PATH" "$NEW_PATH"

	# Remove all lines containing one of the setting keywords used for controlling Vim indentation.
	cat $NEW_PATH | grep -Ev 'expandtab' | grep -Ev 'shiftwidth' | grep -Ev 'softtabstop' | grep -Ev 'tabstop' > $OLD_PATH
done



# Universal Ctags compilation is needed for tagbar.
echo
echo "Compiling and installing Universal Ctags (requirement of Tagbar) ..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
git clone https://github.com/universal-ctags/ctags.git
if [ "$?" != "0" ] ; then echo "Error trying to download Universal Ctags" ; exit ; fi
cd ctags
./autogen.sh
./configure
make
make install
cd ..
rm -rf ctags



# Install Pyflakes
echo
echo "Installing Pyflakes ..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
git clone https://github.com/pyflakes/pyflakes.git
if [ "$?" != "0" ] ; then echo "Error trying to download Pyflakes" ; exit ; fi
cd pyflakes
/usr/bin/env python3 $HOME_DIRECTORY/pyflakes/setup.py install
cd ..
rm -rf pyflakes



# Pathogen is used to load other vim plugins.
echo
echo "Installing Pathogen..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY

if [ -e ".vim" ] ; then 
	OLD_VIM_DIR_CREATION_TIME=`ls -dl --time=ctime --time-style=+%F_at_%R .vim | awk '{ print $6 }'`
	OLD_VIM_DIR_NAME=".vim_$OLD_VIM_DIR_CREATION_TIME"
	mv -f .vim $OLD_VIM_DIR_NAME
fi

mkdir -p .vim/autoload .vim/bundle
cd .vim/autoload
wget https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
if [ "$?" != "0" ] ; then echo "Error trying to download pathogen" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# Install C reference documents
echo
echo "Installing C language reference documents ..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
mkdir -p .vim/plugin .vim/doc .vim/after/syntax
git clone https://github.com/vim-scripts/CRefVim.git
if [ "$?" != "0" ] ; then echo "Error trying to download C reference documents" ; exit ; fi
cp CRefVim/plugin/crefvim.vim $HOME_DIRECTORY/.vim/plugin/
cp CRefVim/doc/crefvimdoc.txt $HOME_DIRECTORY/.vim/doc/
cp CRefVim/doc/crefvim.txt $HOME_DIRECTORY/.vim/doc/
cp CRefVim/after/syntax/help.vim $HOME_DIRECTORY/.vim/after/syntax
rm -rf CRefVim



# Tagbar
echo
echo "Installing Tagbar..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone http://github.com/majutsushi/tagbar
if [ "$?" != "0" ] ; then echo "Error trying to download Tagbar" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/


# Gutentags
echo
echo "Installing Gutentags..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone https://github.com/ludovicchabant/vim-gutentags.git
if [ "$?" != "0" ] ; then echo "Error trying to download Gutentags" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/


# Syntastic
echo
echo "Installing Syntastic"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone https://github.com/scrooloose/syntastic.git
if [ "$?" != "0" ] ; then echo "Error trying to download Syntastic" ; exit ; fi
# A older version needed to be cehecked out of the git repository in 2013 to work around a bug that got introduced in a newer version
# cd syntastic
# git checkout ec434f50b189b3ba990052bd237e1da4f9c9c576
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# Supertab
echo
echo "Installing Supertab"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone https://github.com/ervandew/supertab.git
if [ "$?" != "0" ] ; then echo "Error trying to download Supertab" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# PyDoc
echo
echo "Installing PyDoc"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone https://github.com/fs111/pydoc.vim.git
if [ "$?" != "0" ] ; then echo "Error trying to download PyDoc" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# vim-fugitive
echo
echo "Installing Vim-Fugitive"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone https://github.com/tpope/vim-fugitive.git
if [ "$?" != "0" ] ; then echo "Error trying to download Vim-Fugitive" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# GitGutter
echo
echo "Installing GitGutter"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone https://github.com/airblade/vim-gitgutter.git
if [ "$?" != "0" ] ; then echo "Error trying to download GitGutter" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# Nerdtree
echo
echo "Installing Nerdtree"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone https://github.com/scrooloose/nerdtree.git
if [ "$?" != "0" ] ; then echo "Error trying to download Nerdtree" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# Surround
echo
echo "Installing Surround"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone https://github.com/tpope/vim-surround
if [ "$?" != "0" ] ; then echo "Error trying to download Surround" ; exit ; fi
cd $HOME_DIRECTORY
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# Remove bad looking color schemes that ship with vim
echo
echo "Deleting bad color schemes that ship with vim..."
echo "--------------------------------------------------------------------------------"
rm -v /usr/share/vim/$VIM_VERSION/colors/blue.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/darkblue.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/delek.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/elflord.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/evening.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/koehler.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/morning.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/pablo.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/peachpuff.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/ron.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/shine.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/torte.vim
rm -v /usr/share/vim/$VIM_VERSION/colors/zellner.vim



# Download and install 256 color colorschemes
echo
echo "Installing 256 color schemes..."
echo "--------------------------------------------------------------------------------"
cd /usr/share/vim/$VIM_VERSION/colors/
# Remove old versions of color schemes we are about to download
rm -f jellybeans.vim
rm -f desert256.vim
rm -f distinguished.vim
rm -f solarized.vim

# Install modified colorschemes aldmeris, distinguished and jellybeans
echo
echo "Installing modified colorschemes Aldmeris, Distinguished and Jellybeans..."
echo "--------------------------------------------------------------------------------"
echo

cp -v $PATH_TO_MODIFIED_COLOR_SCHEMES_DIR/desert256.vim /usr/share/vim/$VIM_VERSION/colors/
cp -v $PATH_TO_MODIFIED_COLOR_SCHEMES_DIR/aldmeris.vim /usr/share/vim/$VIM_VERSION/colors/
cp -v $PATH_TO_MODIFIED_COLOR_SCHEMES_DIR/distinguished.vim /usr/share/vim/$VIM_VERSION/colors/
cp -v $PATH_TO_MODIFIED_COLOR_SCHEMES_DIR/jellybeans.vim /usr/share/vim/$VIM_VERSION/colors/



# Write .vimrc
echo
echo "Writing ~/.vimrc"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cat > .vimrc << 'END_OF_FILE'

" Pathogen autoloads other vim plugins we use, it must be started first
call pathogen#infect()
call pathogen#helptags()

" Set on syntax highlighting, indentation, and line numbering
syntax on
filetype plugin on
filetype indent on
set autoindent

" Highlight search results
set hlsearch

" Ignore case in search
set ignorecase 

" Ignore case if the search term is all lowercase
set smartcase

" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=5

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" ctrl + a and ctrl + x increments character / number under cursor
set nrformats=alpha

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set noswapfile

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Set the pydoc info window to 50% size of vim window.
" Pydoc shows docs for python words under cursor with \pw.
let g:pydoc_window_lines=0.5

" Display line numbers when F2 is pressed
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

" Show indentation guides when pressing F3.
noremap <F3> :set list! listchars=tab:\.\ <CR>

" Toggle line wrap when pressing F4                                                                                                                
noremap <F4> :set wrap!<CR>

" Disable autoindent for pasting when F5 is pressed
set pastetoggle=<f5>

" Go to next window when pressing F6
map <F6> <C-W>w

" Toggle NERDTree window by pressing F7
noremap <F7> ::NERDTreeToggle<CR>

" Open Tagbar plugin window when F8 is pressed
nmap <F8> :TagbarToggle<CR>

" Open tag under cursor to a new vertical window
set splitright
nnoremap <F10> :only<bar>vsplit<CR>:execute "tag " . expand('<cword>')<CR>

" Toggle GitGutter display by pressing F9
" First turn it off by default
let g:gitgutter_enabled = 0
noremap <F9> :GitGutterToggle<CR>

" Set characer set encoding to UTF-8
set encoding=utf-8

" Do not wrap lines
set nowrap

" Display ruler
set ruler 

" Hightlight current line
set cul
hi CursorLine term=none cterm=none ctermbg=17

" Show statusline (with the filename, ascii value (decimal), hex value, and the standard lines, cols, 
set statusline=%t%h%m%r%=[%b\ 0x%02B]\ \ \ %l,%c%V\ %P
" Always show a status line
set laststatus=2
"make the command line 1 line high
set cmdheight=1

" The '' command is useless because it always forces the cursor to the start of line after jumping.
" I prefer always to jump to last cursor position insted, I can always go to 0 if I want to.
" The following command forces '' to always jump back to last cursor position.                          
:map '' ``

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Configure Syntastic to open error window when errors are detected
let g:syntastic_auto_loc_list = 1

" Configure Syntastic to use pyflakes for Python syntax checking
let g:syntastic_python_checkers = ["pyflakes"] 

" Configure Syntastic Go syntax checker
let g:syntastic_go_checkers = ["gotype"]

" Configure Syntastic to use the C++17 standard version of the C++ language
let g:syntastic_cpp_compiler_options = '-std=c++17'

" Configure Supertab to complete python3 commands when pressing TAB and showing description of commands in a window.
au FileType python set omnifunc=python3complete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview
let g:SuperTabClosePreviewOnPopupClose = 1

" Colorscheme
set background=dark
colorscheme aldmeris

" Change statusline color in Insertmode
au InsertEnter * hi StatusLine ctermfg=2 ctermbg=0 cterm=reverse,bold
au InsertLeave * hi StatusLine ctermfg=NONE ctermbg=NONE cterm=reverse,bold

" Vim 7.4 changed how identing works, force the old behaviour to always use tabs with width 8.
set tabstop=8
set shiftwidth=8
set noexpandtab



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction 

END_OF_FILE

chown $REAL_USER_NAME:$REAL_USER_NAME .vimrc



echo
echo "Installation is ready :)"
echo
echo "As an additional step I can copy vim settings also to the user root"
echo "This lets you have vim configured correctly when you use sudo or do something as root"
echo
echo "If you don't want this then press ctrl + c now."
echo
read -p "Press [Enter] key to start.."
echo

cd $HOME_DIRECTORY
rm -rf /root/.vim                                                                                                                                                                                                    
rm -f /root/.vim*
mkdir -p /root/.vim
cp -r .vim/ /root/
cp .vimrc /root/


echo
echo "Settings copied :)"
echo
echo "Good terminals for a Vim IDE are:"
echo
echo "LXTerminal"
echo "QTerminal"
echo "KDE Konsole"
echo
echo "Some of these needs to be configured to not capture the 'F2 - F10 keys' so that Vim can use them."
echo "Select a mono font like Terminus, Liberation Mono, Droid Sans Mono, Nimbus Mono as the default font for the Terminal and start writing code :)"
echo
echo


