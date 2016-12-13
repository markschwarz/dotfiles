
workon python27_DS

unalias run-help
autoload run-help
bindkey '^[h' run-help
source /usr/local/share/zsh/site-functions/_aws
export REPORTTIME=10
alias jup='cd ~/notebooks;jupyter notebook'
alias j='jupyter console'
alias glances='glances --enable-history --process-short-name'
alias history='history 1'
alias mail='mutt'

export PYTHONPATH=$RIGHTIMPORT/sqrt_lib:$RIGHTIMPORT/PyLib:$RIGHTIMPORT:/sqrt_utilities

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end
#

_apex()  { # http://apex.run/#autocomplete
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local opts="$(apex autocomplete -- ${COMP_WORDS[@]:1})"
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}

complete -F _apex apex


# Usage:
# source iterm2.zsh
# https://gist.github.com/wadey/1140259
# iTerm2 window/tab color commands
#   Requires iTerm2 >= Build 1.0.0.20110804
#   http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes
tab-color() {
    echo -ne "\033]6;1;bg;red;brightness;$1\a"
    echo -ne "\033]6;1;bg;green;brightness;$2\a"
    echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
tab-reset() {
    echo -ne "\033]6;1;bg;*;default\a"
}

# Change the color of the tab when using SSH
# reset the color after the connection closes
color-ssh() {
    if [[ -n "$ITERM_SESSION_ID" ]]; then
        trap "tab-reset" INT EXIT
        if [[ "$*" =~ "production|prd" ]]; then
            tab-color 255 0 0
        else
            tab-color 0 255 0
        fi
    fi
    ssh $*
}
compdef _ssh color-ssh=ssh

alias ssh=color-ssh

#If zsh installed, gcloud may not work, thus add the following lines to .zshrc file (aka on Terminal run $ vi  /.zshrc)
#zsh install: https://github.com/robbyrussell/oh-my-zsh/
#gcloud sdk install: https://cloud.google.com/sdk/
#gcloud zsh completion install: https://github.com/littleq0903/gcloud-zsh-completion

#gcloud
export PATH="$HOME/scripts/google-cloud-sdk/bin:$PATH"

#gcloud zsh completion
fpath=(~/github/gcloud-zsh-completion/src $fpath)

autoload -U compinit compdef
compinit
