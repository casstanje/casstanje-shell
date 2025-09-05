#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W ]$ '
export LS_OPTIONS='--color=auto'
eval "$(dircolors -b ~/.dircolors)"
alias ls='ls $LS_OPTIONS'

# Run fastfetch (just comment the line hereunder out if you don't want it)
source $HOME/.config/casstanje-shell/casstanje-fastfetch.sh
