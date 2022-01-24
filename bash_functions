#
# BASH FUNCTIONS
#

function isSSH {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        SESSION_TYPE=remote/ssh
        # many other tests omitted
    else
        case $(ps -o comm= -p $PPID) in
            sshd|*/sshd) SESSION_TYPE=remote/ssh;;
        esac
    fi
}

# Get the current active jobs
function jobsNumber {
    # current jobs = stopped jobs + running jobs - jobs done
    jobs_number=$(( $(jobs -ps | wc -l) + $(jobs -pr | wc -l) - $(jobs -r | grep -c Done) ))
}

# Get some basic git infos
function gitInfo {
	unalias ls;
	status_short=$(git status --porcelain 2>&1)
	if ! [[ $status_short =~ 'fatal' ]]; then
		status_long=$(git status)
		diverged=$(echo "$status_long" | grep -c diverged)
		new_files=$(echo "$status_short" | grep -c -o -e '?? ' -e ' D ' -e ' M ')
		staged_files=$(git diff --cached --numstat | wc -l)
        git_root=$(basename $(git rev-parse --show-toplevel))
        git_branch=$(git branch | grep '*' | sed 's/\* //')
		alias ls="exa -F --git --icons --color=auto --group-directories-first"
		if [ "$diverged" -gt 0 ]; then
			ahead_commits=$(echo "$status_long" | tr ' ' '\n' | grep '[0-9]' | sed -n '1 p')
			behind_commits=$(echo "$status_long" | tr ' ' '\n' | grep '[0-9]' | sed -n '2 p')
		else
			# ahead_commits=$(git status | grep ahead | awk '{print $((NF-1))}')
			# behind_commits=$(git status | grep behind | awk '{print $((NF-1))}')
			ahead_commits=$(git status | grep ahead | sed -e 's/.*by \(.*\) commit.*/\1/')
			behind_commits=$(git status | grep behind | sed -e 's/.*by \(.*\) commit.*/\1/')
		fi
	else
		alias ls="exa -F --icons --color=auto --group-directories-first"
		new_files="0"
		staged_files="0"
		ahead_commits="0"
		behind_commits="0"
        git_root=""
	fi
}

# Get a shorter path
function shortPath {
    user=$(whoami)
	current_long=$(pwd | sed "s/\/home\/$user/~/")
	current_short=""
	if [ "$current_long" = "~" ]; then
        	current_short="~"
	else
		current_long=${current_long/\~\/\.config/\.config}
		current_long=${current_long/\~\/Documents/Documents}
		current_long=${current_long/\~\/Downloads/Downloads}
		current_long=${current_long/\~\/Music/Music}
		current_long=${current_long/\~\/Pictures/Pictures}
		current_long=${current_long/\~\/Videos/Videos}
		depth=$(echo "$current_long" | tr '/' '\n' | wc -l)
		for i in $(seq 1 $(( depth - 1 ))); do
				#word=$(pwd | sed "s/\/home\/$user/~/" | cut -d'/' -f "$i")
				word=$(echo "$current_long" | cut -d'/' -f "$i")
				if [ "$word" = ".config" ] || [ "$word" = "Documents" ] || [ "$word" = "Downloads" ] || [ "$word" = "Music" ] || [ "$word" = "Pictures" ] || [ "$word" = "Videos" ]; then
					char=$word
                elif [ -n "$git_root" ] && [ "$word" = "$git_root" ]; then
					char=$word
				elif [[ $word == .* ]]; then
					char=$(echo "$word" | cut -c1-2)
				else
        			char=$(echo "$word" | cut -c1-1)
				fi
        		current_short="${current_short}${char}/"  
		done
		current_short="${current_short}${PWD##*/}"
	fi
}

# Create the regular prompt
function buildPrompt {
	gitInfo
	shortPath

	if [ "$SESSION_TYPE" = "remote/ssh" ]; then
		ssh_string="[SSH]"
	else
		ssh_string=""
	fi

	if [ "$jobs_number" -gt 0 ]; then
		jobs_string="[⚒ $jobs_number]"
	else
		jobs_string=""
	fi

	if ! [ "$exit_code" -eq 0 ]; then
		if [ "$exit_code" -eq 148 ]; then
			exit_string="[]"
		else
			exit_string="[×]"
		fi
	else
		exit_string=""
	fi

	if [ "$new_files" -gt 0 ]; then
		new_string=" \[\e[0;31m\]◯ $new_files\[\e[0;00m\]"
	else
		new_string=""
	fi

	if [ "$staged_files" -gt 0 ]; then
		staged_string=" \[\e[0;32m\]● $staged_files\[\e[0;00m\]"
	else
		staged_string=""
	fi

	if ! [[ $status_short =~ 'fatal' ]]; then
		if [ "$diverged" -gt 0 ]; then
			git_symbol=" \[\e[1;31m\]⎇\[\e[0;00m\] "
		else
			git_symbol=" \[\e[1;37m\]⎇\[\e[0;00m\] "
		fi
	else
		git_symbol=""
	fi

	if [ -n "$ahead_commits" ] && [ "$ahead_commits" -gt 0 ]; then
		ahead_string=" \[\e[0;34m\]↑ $ahead_commits\[\e[0;00m\]"
	else
		ahead_string=""
	fi

	if [ -n "$behind_commits" ] && [ "$behind_commits" -gt 0 ]; then
		behind_string=" \[\e[0;33m\]↓ $behind_commits\[\e[0;00m\]"
	else
		behind_string=""
	fi

	git_prompt="$git_symbol$git_branch $ahead_string$behind_string$new_string$staged_string"
	PS1="$ssh_string$jobs_string${exit_string}[\h:$current_short$git_prompt]\$ "
}

function buildNerdPrompt {
	color=''
	if [ "$SESSION_TYPE" = "remote/ssh" ]; then
		if [ -n "$color" ]; then
			ssh_nerd="\[\033[0;3$color;42m\]\[\033[30m\] ﱾ \[\033[0m\]"
		else
			ssh_nerd="\[\033[0;30;42m\] ﱾ \[\033[0m\]"
		fi
		color='2'
	else
		ssh_nerd=""
	fi

	if [ "$jobs_number" -gt 0 ]; then
		if [ -n "$color" ]; then
			jobs_nerd="\[\033[0;3$color;45m\]\[\033[30m\] ⚒ $jobs_number \[\033[0m\]"
		else
			jobs_nerd="\[\033[0;30;45m\] ⚒ $jobs_number \[\033[0m\]"
		fi
		color='5'
	else
		jobs_nerd=""
	fi

	if ! [ "$exit_code" -eq 0 ]; then
		if [ "$exit_code" -eq 148 ]; then
			if [ -n "$color" ]; then
				exit_nerd="\[\033[0;3$color;43m\]\[\033[30m\]  \[\033[0m\]"
			else
				exit_nerd="\[\033[0;30;43m\]  \[\033[0m\]"
			fi
			color='3'
		else
			if [ -n "$color" ]; then
				exit_nerd="\[\033[0;3$color;41m\]\[\033[30m\] ✖ \[\033[0m\]"
			else
				exit_nerd="\[\033[0;30;41m\] ✖ \[\033[0m\]"
			fi
			color='1'
		fi
	else
		exit_nerd=""
	fi

	gitInfo
	shortPath

	if [ "$current_short" = "/" ]; then
		current_short=" "
	else
		# current_short=$(echo "$current_short" | sed 's/^[\/]/ \\[\\033\[01;30m\\]\\[\\033\[0;30;44m\\]/')
		current_short=$(echo "$current_short" | sed 's/^[\/]/ |/')
		current_short=${current_short/\~/ } #
		# current_short=${current_short//\//\\[\\033\[01;30m\\]\\[\\033\[0;30;44m\\]}
		current_short=${current_short//\//|}
		current_short=${current_short/\.config/ }
		current_short=${current_short/Documents/ }
		current_short=${current_short/Downloads/ }
		current_short=${current_short/Music/ }
		current_short=${current_short/Pictures/ }
		current_short=${current_short/Videos/ }
	fi
	if [ -n "$color" ]; then
		current_short="\[\033[0;3$color;44m\]\[\033[30m\] $current_short\[\033[0m\]"
	else
		current_short="\[\033[0;30;44m\] $current_short\[\033[0m\]"
	fi
	color='4'

    if [ -n "$VIRTUAL_ENV" ]; then
        venv_nerd="\[\033[0;3$color;45m\]\[\033[30m\]  \[\033[0m\]"
        color='5'
    else
        venv_nerd=""
    fi

	nerd_git_prompt=''
	if ! [[ $status_short =~ 'fatal' ]]; then
		remote=$(git remote -v | grep -c -i github)
		if [ "$remote" -gt 0 ]; then
			git_symbol="  "
		else
			git_symbol="  "
		fi
		#git_prompt=" "
		nerd_git_prompt="\[\033[0;3$color;42m\]\[\033[0m\]\[\033[0;30;42m\]$git_symbol┊$git_branch\[\033[0m\]\[\033[0;32m\]\[\033[0m\]"
		# color='2'
		if [ "$new_files" -gt 0 ] || [ "$staged_files" -gt 0 ]; then
			if [ -n "$ahead_commits" ] && [ "$ahead_commits" -gt 0 ]; then
				git_prompt="  $ahead_commits "
			else
				git_prompt=' '
			fi
			if [ "$new_files" -gt 0 ]; then
				git_prompt="$git_prompt $new_files"
                space=' '
            else
                space=''
            fi
			if [ "$staged_files" -gt 0 ]; then
				git_prompt="$git_prompt$space $staged_files"
			fi
			nerd_git_prompt="\[\033[0;3$color;43m\]\[\033[0m\]\[\033[0;30;43m\]$git_symbol┊$git_branch$git_prompt\[\033[0m\]\[\033[0;33m\]\[\033[0m\]"
		    if [ -n "$behind_commits" ] && [ "$behind_commits" -gt 0 ]; then
                :
            else
                color='3'
            fi
		else
			if [ -n "$ahead_commits" ] && [ "$ahead_commits" -gt 0 ]; then
				git_prompt="  $ahead_commits"
				nerd_git_prompt="\[\033[0;3$color;42m\]\[\033[0m\]\[\033[0;30;42m\]$git_symbol┊$git_branch$git_prompt\[\033[0m\]\[\033[0;32m\]\[\033[0m\]"
				color='2'
			else
				git_prompt=''
			fi
		fi
		if [ -n "$behind_commits" ] && [ "$behind_commits" -gt 0 ]; then
			git_prompt=" $behind_commits$git_prompt"
			nerd_git_prompt="\[\033[0;3$color;41m\]\[\033[0m\]\[\033[0;30;41m\]$git_symbol┊$git_branch $git_prompt\[\033[0m\]\[\033[0;31m\]\[\033[0m\]"
			color='1'
		fi
	else
		nerd_git_prompt="\[\033[0m\]\[\033[0;3${color}m\]\[\033[0m\]"
	fi
	PS1="$ssh_nerd$jobs_nerd$exit_nerd$current_short$venv_nerd$nerd_git_prompt "
}

# Functions to call after every command
function pc {
	exit_code="$?"
	isSSH
	jobsNumber
	# buildPrompt
	buildNerdPrompt
	export PS1
}
export PROMPT_COMMAND=pc

