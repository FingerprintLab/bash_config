# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ $HOME/.local/bin:$HOME/bin: ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Include npm global packages in the PATH
# PATH="$HOME/.npm-packages/bin:$PATH:$HOME/.emacs.d/bin"
export PATH

export MANPATH="${MANPATH-$(manpath)}:$HOME/.npm-packages/share/man"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Aliases
if [ -f "$HOME/.bash_aliases" ]; then
	. "$HOME/.bash_aliases"
fi

# Functions
if [ -f "$HOME/.bash_functions" ]; then
	. "$HOME/.bash_functions"
fi

# Uncomment the following lines if you want the st terminal to use the dark theme variant by default
# if [ "$TERM" = "st-256color" ]; then
#     xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT "dark" -id $(xdotool getactivewindow)
#     cd $HOME
# fi

