#
# ~/.bashrc
#


# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$ '
#PS1='\[\033[1;37m\] \w \[\033[1;36m\]>\[\033[0;37m\] '


#VIMRC
export VIMINIT="source ~/.config/vim/vimrc"


#Starship Prompt
eval "$(starship init bash)"

