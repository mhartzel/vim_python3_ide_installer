# Vim as Python3 and C IDE

This is my shell script to install vim and other packages so that I can use vim as my Python3 and C development environment.

### This version of the install script is for Debian / Ubuntu.

Manjaro install script can be found here: https://github.com/mhartzel/vim_python3_ide_installer-manjaro

This program will do the following things:
- Uninstall previous vim packages and old vim configuration.
- Download latest vim source from git repository. Compile and install a new vim with Python3 support.
- Download and install 256 color Terminus font.
- Install vim plugins Pathogen and Tagbar to make vim an IDE.
- Install Syntastic and Pyflakes.
- Install Supertab and Pydoc.
- Install Gutentags
- Install vim-gitgutter.
- Install git-fugitive.
- Install Nerdtree.
- Install Surround.
- Install C language reference documents.
- Remove most color schemes that come with vim, leaving only: default, desert, murphy and slate.
- Install 256 color vim colorschemes: desert256, distinguished, jellybeans, aldmeris (based on oblivion colorscheme for Gedit).
- All colorschemes are modified to show the current line as a 1 pixel underline.
- Aldmeris default color for statements (white) is the same as for the rest of text. Statements should stand out, so the color is changed to green.
- Colorscheme aldmeris is set as the default colorscheme.

After installation you have:

- Python3 syntax checking (every time you save).
- Python3 syntax highlighting.
- Python3 documentation for the keyword under cursor opens with leader + pw  ( \pw  NOTE second character must be pressed within 1 second ).
- C syntax checking (every time you save)
- C syntax highlighting.
- C++17 syntax checking (every time you save)
- C reference documentation for the keyword under cursor opens with leader + cr  ( \cr  NOTE second character must be pressed within 1 second ).
- Gutentags will automatically create a tag - file for subroutines in your code when you open it up for editing.
- The current line is underlined with a single pixel white line (all colorschemes). 
- F2 - turns on/off line numbers.
- F3 - turns on/off ident guidelines
- F4 - turns on/off line wrapping
- F5 - turns on/off automatic identation (needs to be turned off when pasting text into vim).
- F6 - jump to next window
- F7 - open nerdtree to navigate the filesystem.
- F8 - turns on/off Tagbar.
- F9 - turns gitgutter on /off
- F10 - Show subroutine definition for the one under cursor even if the definition is in another file in the project
- Tagbar shows your function names and variables in a small window on the right side of vim display.
- Tagbar also shows you the 'scope' meaning it highlights the function name the current code line belongs to.
- Pressing enter in Tagbar window on a function name makes the main window jump to that function.
- Matching brackets are automatically highlighted.
- Vim-Gitgutter shows what lines you have changed since committing that file to git (display refreshes every 4 seconds)
- Nerdtree lets you navigate the filesystem and open files.
- Git-fugitive lets you commit to your git repository right from vim.
- Surround lets you easily add change quotes, brakets, etc around a text block: https://github.com/tpope/vim-surround
- Search results are highlighted.
- Case is ignored in search.
- Vim remembers the code line that you were in last time the file was open.
- '' is mapped to `` meaning that the command '' returns to the line and character you were on before a jump in the text.
- Backspace configured to work like it should.
- Good terminals for a Vim IDE are: LXTerminal, QTerminal, KDE Konsole.



# Installation

### Requirements: Debian, Ubuntu or another Debian based Linux distro

> git clone https://github.com/mhartzel/vim_python3_ide_installer.git

> cd vim_python3_ide_installer

> ./install_vim_and_packages_required_for_python3_ide.sh


# Screenshots

## Toggle line numbers and indent guides on / off

```ruby
Toggle line numbers on/off with F2
```
```ruby
Toggle indent guides on/off with F3
```

![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/Line_numbers-indent_guides.png)


## Tagbar shows the current 'scope' and lets jump to function and variable definitions
```ruby
Toggle Tagbar on/off with F8
```
> http://github.com/majutsushi/tagbar

![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/tagbar.png)

## Statusline changes color to green when vim is in Insert - mode
![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/statusline.png)

## Python3, C, C++, etc syntax checking
> https://github.com/vim-syntastic/syntastic

> https://github.com/pyflakes/pyflakes.git

![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/aldmeris-Syntastic-Pyflakes.png)


## Complete keywords by pressing Tab
> https://github.com/ervandew/supertab.git

![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/aldmeris-Supertab.png)


## View documentation for the keyword under cursor

```
Python3: leader + pw ( \pw )
```
```
C: leader + cr ( \cr )
```
> https://github.com/fs111/pydoc.vim.git

![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/aldmeris-Supertab-Pydocs.png)


## Show subroutine definition
```ruby
Show subroutine definition with F10
```
![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/aldmeris-Show_Function_Definition.png)


## Vim-Gitgutter shows what lines you have changed since committing that file to git (display refreshes every 4 seconds).
```ruby
Toggle Gitgutter on/off with F9
```
> https://github.com/airblade/vim-gitgutter

![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer-manjaro/master/Pictures/aldmeris-256-gitgutter.png)


## Nerdtree lets you navigate the filesystem and open files.
```ruby
Open Nerdtree with F7 and close with q 
```
> https://github.com/scrooloose/nerdtree

![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer-manjaro/master/Pictures/aldmeris-nerdtree.png)


## Git-fugitive lets you commit to your git repository right from vim.
```ruby
Gwrite or Gw = git add .
Gstatus or Gst = git status
Gcommit or Gco = git commit
```
> https://github.com/tpope/vim-fugitive

![aldmeris](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer-manjaro/master/Pictures/aldmeris-git-fugitive.png)


# Colorschemes

## Desert256 colorscheme
![Desert256](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/desert256.png)


## Aldmeris256 colorscheme (based on oblivion colorscheme for Gedit)
![Desert256](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/aldmeris256.png)


## Distinguished colorscheme (256 colors)
![Distinguisged256](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/distinguished.png)


## Jellybeans colorscheme (256 colors)
![Jellybeans256](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/jellybeans.png)


## Murphy colorscheme (8 colors)
![Murphy8](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/murphy.png)


## Slate colorscheme (8 colors)
![Slate8](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/slate.png)


## Vims own default colorscheme (8 colors)
![Vim8](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/vims_own_default_colorscheme.png)

## Desert colorscheme (8 colors)
![Vim8](https://raw.githubusercontent.com/mhartzel/vim_python3_ide_installer/master/Pictures/desert8.png)


