alias c="clear"
alias cl="clear"
alias cls="clear"

alias ls="exa -F --icons --color=auto --group-directories-first"
alias la="ls -la"
alias ll="ls -l"
alias l="ll"
# alias ls="ls -hCF --color=auto --group-directories-first"
# alias la="ls -lA"

# if you do not specity an argument it takes you to the parent folder otherwise it travels up N times in the tree 
alias up=". ~/bin/up.sh"

alias p="pwd"
alias fd="fd -H"
alias cal="cal -m"
alias hist="history"
alias path='echo -e ${PATH//:/\\n}'
alias src="source ~/.bashrc"

alias catn="cat -n"
alias less="less -FSRXc"
alias grep="grep --color=auto -i"

alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
alias mkdir="mkdir -pv"

alias fman="ranger"
alias files="nautilus"
alias start="nautilus"

alias d="date +%d/%m/%y"
alias t="date +%T"

# Screenshots
alias ss_save="maim ~/Pictures/Screenshots/$(date +%d_%m_%Y-%H_%M_%S).png"
alias ss_copy="maim | xclip -selection clipboard -t image/png"
alias ssw_save="maim -s | convert - \( +clone -background black -shadow 100x5+0+0 \) +swap -background none -layers merge +repage ~/Pictures/Screenshots/$(date +%d_%m_%Y-%H_%M_%S).png"
alias ssw_copy="maim -s | convert - \( +clone -background black -shadow 100x5+0+0 \) +swap -background none -layers merge +repage /tmp/screenshot.png; xclip -selection clipboard -t image/png /tmp/screenshot.png"
alias ssr_save="maim -s ~/Pictures/Screenshots/$(date +%d_%m_%Y-%H_%M_%S).png"
alias ssr_copy="maim -s | xclip -selection clipboard -t image/png"

alias jobs="jobs -l"
alias dis="disown"

alias q="exit"
alias shutdown="shutdown now"
alias shdn="shutdown"

# Fedora package manager aliases
#alias din="sudo dnf install"
#alias dun="sudo dnf remove"
#alias dup="sudo dnf update"
#alias dsh="dnf search"

alias v="nvim"
alias e="emacs"
alias em="emacs -nw"
alias py3="python3"

# alias typescript-language-server="typescript-language-server --stdio"
