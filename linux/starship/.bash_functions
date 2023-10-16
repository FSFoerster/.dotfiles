#!/usr/bin/env bash

function prompt_command_starship() {
	eval "$(starship init bash)"
}

function prompt_command_tiny() {
    local exitcode="$?"
    local split=2
    local workingdir="$(pwd | sed 's@'"$HOME"'@~@')"
    W=${workingdir}
    if [[ $(echo ${W} | grep -o '/' | wc -l) -gt ${split} ]]; then
        workingdir=$(echo $W | cut -d'/' -f1-$split | xargs -I{} echo {}"/../${W##*/}")
    fi
    PS1="\n┌[\u@\h]──[${workingdir}]──[\@]\n└────╼ "
}
