# Bash configuration files

This is my custom bash configuration inspired by [zsh powerline](https://github.com/romkatv/powerlevel10k).

## Instructions

In order to test it you should save a backup of your current bash configuration files.
```sh
# make a backup directory
mkdir -p ~/.config/bash.BAK

# move your files in the new folder
mv ~/.bash* ~/.config/bash.BAK/
```

### Requirements & dependencies

If you want that nice powerline feeling you must use a [nerdfont](https://www.nerdfonts.com/font-downloads) otherwise you should uncomment `buildPrompt` and comment `buildNerdPrompt` at the end of `bash_functions`.  

You also need the following (optional) dependencies:
- git: obviously
- [neovim](https://neovim.io/): c'mon you know it. If you don't use it make sure to change `EDITOR` and `VISUAL` values in `bash_profile`.
- [exa](https://the.exa.website/): a modern replacement for `ls`. I use it extensively so, if you don't want it, make sure to remove (or comment) the lines 24, 33 and 44 on `bash_functions` and check also `bash_aliases` in order to uncomment the "pure" `ls` aliases and comment the `exa` ones.
- [ranger](https://github.com/ranger/ranger): terminal file manager. If you prefer another terminal file manager make sure to change the corresponding alias.
- [nautilus](https://wiki.gnome.org/action/show/Apps/Files?action=show&redirect=Apps%2FNautilus): graphical file manager (default in Ubuntu). If you prefer another graphical file manager make sure to change the corresponding aliases.

Screenshots work on X11 only and need the following dependencies:
- [maim](https://github.com/naelstrof/maim): screenshot utility
- [xclip](https://github.com/astrand/xclip): clipboard interface utility on X11

### Install

It's pretty straight forward. You just have to clone the repository and copy the files.

```sh
# clone the repository
git clone https://github.com/FingerprintLab/bash_config.git
cd bash_config

# copy the bash files over to your home directory
cp ./bashrc ~/.bashrc
cp ./bash_aliases ~/.bash_aliases
cp ./bash_functions ~/.bash_functions
cp ./bash_profile ~/.bash_profile

# copy the up.sh script
! [ -d ~/bin ] && mkdir ~/bin || :
cp ./up.sh ~/bin/up.sh
chmod +x ~/bin/up.sh
```

### Uninstall

The backup directory is needed to revert to your previous configuration.

```sh
# remove the current files
rm -f ~/.bash*

# revert to the previous configuration through the backup directory
cp ~/.config/bash.BAK/* ~/
```

