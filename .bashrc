#--------------------------------------------------
#alias
#--------------------------------------------------
#color output
alias ls="ls --color=auto"
alias grep="grep --color=auto"

#--------------------------------------------------
#environment variables
#--------------------------------------------------
#set prompt
export PS1="\u@\h:\w\$ "

#xterm-256
export TERM=xterm-256color

#editor
export EDITOR=vim

#path
export PATH=$HOME/bin:$PATH

#debian packaging
export DEBFULLNAME=lainme
export DEBEMAIL=lainme993@gmail.com
export DEB_BUILD_OPTIONS=nocheck
export QUILT_PATCHES=debian/patches
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"

#--------------------------------------------------
#others
#--------------------------------------------------
#bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
