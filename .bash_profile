# .bash_profile

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
export HISTTIMEFORMAT='%F %T '

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# --- Function-Convenience
# Added in .bashrc -- . /mnt/data_dev/Datawarehouse/Keyfiles/user_environment_variable_setup.sh
alias git-stash-v='git stash list --format="%gd %cr %ae %h %s"'
alias ec2-get-instance-name='curl -s http://169.254.169.254/latest/meta-data/instance-id'
alias di='aws ec2 describe-instances --instance-id=`ec2-get-instance-name`'


ENV=/mnt/env
#PYTHON_BIN=$ENV/python26/bin/
#PATH=$PYTHON_BIN:$PATH:$HOME/bin
PATH=$PATH:$HOME/scripts
export PATH
export TZ='/usr/share/zoneinfo/US/Central'

# Assumes Python virtualenvwrapper is installed.
export WORKON_HOME=~/.virtualenvs # needed for virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export VIRTUAL_ENV_DISABLE_PROMPT=1
source /usr/local/bin/virtualenvwrapper.sh
#--- Reminderscripts


# --- Form-Beauty
export CLICOLOR=1 # Mac colors for ls command
hostnamecolor=$(hostname | od | tr ' ' '\n' | awk '{total = total + $1}END{print 30 + (total % 6)}')
PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\[\e[${hostnamecolor}m\]\]\h (`basename ${VIRTUAL_ENV-""}`) \[\e[32m\]\w\[\e[0m\]\n$ '

PATH=/opt/local/bin:$PATH

source ~/.bash_profile_site_specific


test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
