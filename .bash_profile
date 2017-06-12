# .bash_profile
#set -x

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# --- Authorization
# User specific environment and startup programs
# Borrowed from http://stackoverflow.com/questions/18880024/start-ssh-agent-on-login
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi


# --- Audit
# export HISTCONTROL=ignoredups:erasedups  # no duplicate entries -- if you do this, it causes history to align !99 style commands unhelpfully
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it
shopt -s cmdhist # http://unix.stackexchange.com/questions/109032/how-to-get-a-history-entry-to-properly-display-on-multiple-lines
shopt -s lithist
export HISTTIMEFORMAT='%F %T '

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Correct behavior with crontab
export EDITOR=vim

# --- Function-Convenience
# Added in .bashrc -- . /mnt/data_dev/Datawarehouse/Keyfiles/user_environment_variable_setup.sh
alias git-stash-v='git stash list --format="%gd %cr %ae %h %s"'
alias ec2-get-instance-name='curl -s http://169.254.169.254/latest/meta-data/instance-id'
alias di='aws ec2 describe-instances --instance-id=`ec2-get-instance-name`'
alias jup='cd ~/notebooks;jupyter notebook'

ENV=/mnt/env
PATH=$PATH:$HOME/scripts
PYTHON_BIN=$ENV/python26/bin/
PATH=$PYTHON_BIN:$PATH:$HOME/bin:$HOME/scripts
export PATH
export TZ='/usr/share/zoneinfo/US/Central'

# Assumes Python virtualenvwrapper is installed.
export WORKON_HOME=~/.virtualenvs # needed for virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=~/.virtualenvs/py3_virtualenvwrapper/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export VIRTUAL_ENV_DISABLE_PROMPT=1
source /usr/local/bin/virtualenvwrapper.sh
#--- Reminderscripts


# --- Form-Beauty
export CLICOLOR=1 # Mac colors for ls command
hostnamecolor=$(hostname | od | tr ' ' '\n' | awk '{total = total + $1}END{print 30 + (total % 6)}')
PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\[\e[${hostnamecolor}m\]\]\h (`basename ${VIRTUAL_ENV-""}`) \[\e[32m\]\w\[\e[0m\]\n$ '

man() {
    env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
    }


#PATH=/opt/local/bin:$PATH

source ~/.bash_profile_site_specific


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end


# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='simple'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
#source $BASH_IT/bash_it.sh
