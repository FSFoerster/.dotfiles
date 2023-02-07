#!/usr/bin/env bash
#
# +-------------------------------------------------------------------------+
# | .bashrc                                                                 |
# +-------------------------------------------------------------------------+
# | Copyright © 2019 Waldemar Schroeer                                      |
# |                  waldemar.schroeer(at)rz-amper.de                       |
# +-------------------------------------------------------------------------+


# User specific aliases and functions
alias vi='vim' 2>/dev/null
alias ll='exa -laghm --group-directories-first' 2>/dev/null
alias l='exa -lghm --group-directories-first' 2>/dev/null
alias grep='grep -i --color=auto' 2>/dev/null
alias s='su - root' 2>/dev/null
alias cp='cp -ir' 2>/dev/null
alias rm='rm -rf' 2>/dev/null
alias mkdir='mkdir -p' 2>/dev/null
alias ..='cd ..' 2>/dev/null
alias ...='cd ../..' 2>/dev/null
alias claer='clear' 2>/dev/null
alias clera='clear' 2>/dev/null
alias yeet='exit' 2>/dev/null

fortune | cowsay -n

eval "$(starship init bash)"
