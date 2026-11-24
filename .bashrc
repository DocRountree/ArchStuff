#
# ~/.bashrc: interactive shells only. PATH and other environment live in
# ~/.bash_profile, so scripts see them too.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# History: big, no duplicates or space-prefixed commands, shared between
# terminals (appended when each command finishes, not when the shell exits)
HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T  '
shopt -s histappend checkwinsize
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Tab completion for commands' options, packages, git branches, ...
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# Prompt: same layout as before, in Greenleaf green
PS1='\[\e[38;2;122;168;74m\][\u@\h \W]\$\[\e[0m\] '

# Vite+ shell function (vp env use); its PATH part is already set at login
. "$HOME/.config/vite-plus/env"
