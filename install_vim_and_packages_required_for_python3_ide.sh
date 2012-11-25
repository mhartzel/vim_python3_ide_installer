#!/bin/bash

if [ "$UID" != "0" ] ; then echo ; echo "This script must be run as root" ; echo ; exit ; fi

echo
echo "This program will do the following things:"
echo
echo "- Uninstall previous vim packages and compile and install a new one with Python3 support."
echo "- Download and install 256 color capable urxvt terminal emulator and set it up to use the clipboard and the Terminus font ."
echo "- Install vim plugins Pathogen and Tagbar plugins to make vim a Python3 IDE."
echo "- Remove most color schemes that comes with vim, leaving only: default, desert, murphy and slate."
echo "- Install 256 color vim color schemes: desert256, distinguished, jellybeans, solarized."
echo
echo "If you don't want this then press ctrl + c now."
echo
read -p "Press [Enter] key to start.."
echo

REAL_USER_NAME=`logname`
HOME_DIRECTORY=`getent passwd $REAL_USER_NAME | cut -d: -f6`



# Remove previous vim installations and install dependencies
echo "Removing apt vim packages..."
echo "--------------------------------------------------------------------------------"
apt-get -y remove vim vim-addon-manager vim-common vim-tiny vim-runtime vim-nox
echo
echo "Installing dependencies with apt-get ..."
apt-get -y install git mercurial python3 python3-dev libncurses5-dev build-essential rxvt-unicode-256color xfonts-terminus xclip



# Compile and install vim.
echo
echo "Compiling and installing vim..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
rm -rf vim
hg clone https://vim.googlecode.com/hg/ vim
cd vim
./configure --with-features=normal --enable-python3interp --enable-multibyte --disable-gui --prefix=/usr
make -j4
make install
cd $HOME_DIRECTORY
rm -rf vim



# Exuberant Ctags compilation is needed for tagbar.
echo
echo "Compiling and installing Exuberant Ctags (a requirement of Tagbar) ..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
wget http://downloads.sourceforge.net/project/ctags/ctags/5.8/ctags-5.8.tar.gz
tar xzvf ctags-5.8.tar.gz
cd ctags-5.8
./configure
make
make install
cd ..
rm -rf ctags-5.8



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
wget https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/



# Tagbar
echo
echo "Installing Tagbar..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cd .vim/bundle
git clone git://github.com/majutsushi/tagbar
chown -R $REAL_USER_NAME:$REAL_USER_NAME .vim/


# Remove bad looking color schemes that ship with vim
echo
echo "Deleting bad color schems that ship with vim..."
echo "--------------------------------------------------------------------------------"
rm /usr/share/vim/vim73/colors/blue.vim
rm /usr/share/vim/vim73/colors/darkblue.vim
rm /usr/share/vim/vim73/colors/delek.vim
rm /usr/share/vim/vim73/colors/elflord.vim
rm /usr/share/vim/vim73/colors/evening.vim
rm /usr/share/vim/vim73/colors/koehler.vim
rm /usr/share/vim/vim73/colors/morning.vim
rm /usr/share/vim/vim73/colors/pablo.vim
rm /usr/share/vim/vim73/colors/peachpuff.vim
rm /usr/share/vim/vim73/colors/ron.vim
rm /usr/share/vim/vim73/colors/shine.vim
rm /usr/share/vim/vim73/colors/torte.vim
rm /usr/share/vim/vim73/colors/zellner.vim



# Download and install 256 color colorschemes
echo
echo "Installing 256 color schemes..."
echo "--------------------------------------------------------------------------------"
cd /usr/share/vim/vim73/colors/
# Remove old versions of color schemes we are about to download
rm -f jellybeans.vim
rm -f desert256.vim
rm -f distinguished.vim
rm -f solarized.vim
wget http://www.vim.org/scripts/download_script.php?src_id=17225 -O jellybeans.vim
wget http://www.vim.org/scripts/download_script.php?src_id=4055 -O desert256.vim
wget https://github.com/Lokaltog/vim-distinguished/raw/develop/colors/distinguished.vim
wget https://github.com/altercation/vim-colors-solarized/raw/master/colors/solarized.vim



# Write .vimrc
echo
echo "Writing ~/.vimrc"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cat > .vimrc << 'END_OF_FILE'

" Pathogen autoloads other vim plugins we use, it must be started first
call pathogen#infect()
call pathogen#helptags()

" Open Tagbar plugin window when F8 is pressed
nmap <F8> :TagbarToggle<CR>

" Colorscheme
colorscheme desert256
set background=dark

" Set on syntax highlighting, indentation, and line numbering
syntax on
filetype plugin on
filetype indent on
set autoindent

" Highlight search results
set hlsearch

" Ignore case in search
set ignorecase 

" When searching try to be smart about cases 
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

" Display line numbers when F2 is pressed
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

" Disable autoindent for pasting when F5 is pressed
set pastetoggle=<f5>

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

END_OF_FILE

chown $REAL_USER_NAME:$REAL_USER_NAME .vimrc



# Enable copy paste between urxvt and graphical programs
echo
echo "Writing urxvt copy / paste perl script..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cat > /usr/lib/urxvt/perl/clipboard << 'END_OF_FILE'

#script to copy/paste text in URXVT

#! perl

sub on_sel_grab {
    my $query = $_[0]->selection;
    open (my $pipe,'| /usr/bin/xclip -in -selection clipboard') or die;
    print $pipe $query;
    close $pipe;
}

sub paste {
    my ($self) = @_;
    my $content = `/usr/bin/xclip -loop 1 -out -selection clipboard` ;
    $self->tt_write ($content);
}

sub on_user_command {
    my ($self, $cmd) = @_;
    if ($cmd eq "clipboard:paste") {
        $self->paste;
    }
}

END_OF_FILE



# Write configuration information to ~/.Xresources
echo
echo "Writing ~/.Xresources"
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cat > .Xresources << 'END_OF_FILE'

! General urxvt config
URxvt*saveLines:         65535
URxvt*font: xft:Terminus:pixelsize=14

! Clipboard toiminto urxvt:lle
URxvt.keysym.Shift-Control-V: perl:clipboard:paste
URxvt.iso14755: False
URxvt.perl-ext-common: default,clipboard

! Colors for urxvt
URxvt*foreground: Wheat
URxvt*background: Black

END_OF_FILE

chown $REAL_USER_NAME:$REAL_USER_NAME .Xresources


# Write configuration information to ~/.xsession
echo
echo "Writing configuration to ~/.xsession..."
echo "--------------------------------------------------------------------------------"
cd $HOME_DIRECTORY
cat > .xsession << 'END_OF_FILE'

# Lataa sisään loggautuessa aina fonttiasetus tiedostosta ~./Xresources
if [ -f $HOME/.Xresources ]; then
  xrdb -merge ~/.Xresources
fi

END_OF_FILE

chown $REAL_USER_NAME:$REAL_USER_NAME .xsession


echo
echo "You must restart X for urxvt - terminal changes to take effect or execute the command: xrdb -merge ~/.Xresources"
echo
echo "Done :)"
echo

