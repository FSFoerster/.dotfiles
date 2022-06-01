#!/usr/bin/env bash
#
# +-------------------------------------------------------------------------+
# | .bash_functions                                                         |
# +-------------------------------------------------------------------------+
# | Copyright © 2019 Waldemar Schroeer                                      |
# |                  waldemar.schroeer(at)rz-amper.de                       |
# +-------------------------------------------------------------------------+

function prompt_command_fancy() {
    local exitcode="$?"
    local split=4
    local workingdir=" $(pwd | sed 's@'"$HOME"'@~@')"
    local git=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')

    if [[ ${exitcode} -eq 0 ]]; then
        local exitsymbol=" "
    else
        local exitsymbol=" "
    fi

    if [[ $(id -u) = 0 ]]; then
        local usersymbol=" "
    else
        local usersymbol=" "
    fi

    W=${workingdir}
    if [[ $(echo ${W} | grep -o '/' | wc -l) -gt ${split} ]]; then
        workingdir=$(echo $W | cut -d'/' -f1-$split | xargs -I{} echo {}"/../${W##*/}")
    fi

	 # blue promt
    # PS1="\[\e[38;5;255;48;5;21m\]${usersymbol}\u@\h\[\e[38;5;21;48;5;33m\]\[\e[38;5;255;48;5;33m\]${workingdir}${git}\[\e[38;5;33;48;5;39m\]\[\e[38;5;21;48;5;39m\] \A${exitsymbol}\e[0m\[\e[38;5;39m\e[m\]"
	 # red-grey promt
	 PS1="\[\e[38;5;196;48;5;238m\]${usersymbol}\u@\h\[\e[38;5;238;48;5;0m\]\[\e[48;5;124;38;5;0m\] \[\e[38;5;255;48;5;124m\]${workingdir}${git} \[\e[38;5;124;48;5;196m\] \[\e[38;5;0;48;5;196m\] \A ${exitsymbol}\e[0m\[\e[38;5;196m\e[m\] "
	 # red promt
	 # PS1="\[\e[38;5;255;48;5;88m\]${usersymbol}\u@\h\[\e[38;5;88;48;5;124m\]\[\e[38;5;255;48;5;124m\]${workingdir}${git}\[\e[38;5;124;48;5;196m\]\[\e[38;5;224;48;5;196m\] \A${exitsymbol}\e[0m\[\e[38;5;196m\e[m\] "
	 # green promt
	 # PS1="\[\e[38;5;255;48;5;2m\]${usersymbol}\u@\h\[\e[38;5;2;48;5;40m\]\[\e[38;5;255;48;5;40m\]${workingdir}${git}\[\e[38;5;40;48;5;46m\]\[\e[38;5;2;48;5;46m\] \A${exitsymbol}\e[0m\[\e[38;5;46m\e[m\]"
    # PS1="${exitsymbol}${usersymbol} ${workingdir} ${git}"
}

function prompt_command_tiny() {
    local exitcode="$?"
    local split=2
    local workingdir="$(pwd | sed 's@'"$HOME"'@~@')"
    local git="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')"
    W=${workingdir}
    if [[ $(echo ${W} | grep -o '/' | wc -l) -gt ${split} ]]; then
        workingdir=$(echo $W | cut -d'/' -f1-$split | xargs -I{} echo {}"/../${W##*/}")
    fi
    PS1="\n┌[\u@\h]──[${workingdir}${git}]──[\@]\n└────╼ "

}


