# Vim as Python3 IDE

This is my shell script to install vim and other packages so that I can use vim as my Python3 development environment.

This program will do the following things:

- Uninstall previous vim packages and old vim configuration.
- Compile and install vim from source with Python3 support.
- Download and install 256 color capable urxvt terminal emulator and set it up to use clipboard and the Terminus font.
- Install vim plugins Pathogen and Tagbar to make vim a Python3 IDE.
- Install Syntastic and Pyflakes.
- Install Supertab and Pydoc.
- Remove most color schemes that come with vim, leaving only: default, desert, murphy and slate.
- Install 256 color vim colorschemes: desert256, distinguished, jellybeans, aldmeris (based on oblivion colorscheme for Gedit).
- Sets colorscheme desert256 as the default colorscheme.

After installation you have:

- A 256 color and UTF-8 capable terminal emulator urxvt.
- Basic copy / paste functionality between urxvt and other programs.
- Python3 syntax checking and keyword highlighting.
- Python3 documentation for the keyword under cursor opens with leader + pw  (\ pw  NOTE second character must be pressed within 1 second) .
- The current line is underlined with a single pixel white line (only in colorscheme desert256).
- F2 - turns on/off line numbers.
- F3 - turns on/off ident guidelines
- F5 - turns on/off automatic identation (needs to be turned off when pasting text into vim).
- F8 - turns on/off Tagbar.
- Tagbar shows your function names and variables in a small window on the right side of vim display.
- Tagbar also shows you the 'scope' meaning it highlights the function name the current code line belongs to.
- Pressing enter in Tagbar window on a function name makes the main window jump to that function.
- Matching brackets are automatically highlighted.
- Search results are highlighted.
- Case is ignored in search.
- Vim remembers the code line that you were in last time the file was open.
- '' is mapped to `` meaning that the command '' returns to the line and character you were on before a jump in the text.
- Backspace configured to work like it should.



After installation fire up urxvt and start vim in it :)



- Copy paste in urxvt works like this: text highlighted in urxvt is immediately copied to clipboard when you release the mouse button. Paste with: shift + ctrl +v.
- Copy / paste works between most graphical programs and urxvt, but with for example Gmail it does not work. You can overcome this by installing the small and lightweight clipboard manager: parcellite. As a bonus it remembers your previous clipboard texts also :)


## Syntax checking
![Desert256](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/desert256-Syntastic-Pyflakes.png)


## Complete keywords by pressing Tab
![Desert256](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/desert256-Supertab.png)


## leader + pw shows documentation for the keyword under cursor
![Desert256](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/desert256-Supertab-Pydocs.png)


## Desert256 colorscheme
![Desert256](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/desert256.png)


## Aldmeris256 colorscheme
![Desert256](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/aldmeris256.png)


## Distinguished colorscheme (256 colors)
![Distinguisged256](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/distinguished.png)


## Jellybeans colorscheme (256 colors)
![Jellybeans256](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/jellybeans.png)


## Murphy colorscheme (8 colors)
![Murphy8](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/murphy.png)


## Slate colorscheme (8 colors)
![Slate8](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/slate.png)


## Vims own default colorscheme (8 colors)
![Vim8](http://github.com/mhartzel/vim_python3_ide_installer/raw/master/Pictures/vims_own_default_colorscheme.png)




