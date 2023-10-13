#!/usr/bin/env bash


# <#----------] Variables [----------#>

width=80
backupdir="/tmp/"

BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
YN="(Yes|${BRIGHT}No${NORMAL}) >> "

# <#----------] Functions [----------#>

echo_equals() {
    counter=0
    while [ $counter -lt "$1" ]; do
    printf '='
    (( counter=counter+1 ))
    done
}

echo_title() {
    title=$1
    ncols=$(tput cols)
    nequals=$(((width-${#title})/2-1))
    tput setaf 4
    echo_equals "$nequals"
    tput setaf 6
    printf " %s " "$title"
    tput setaf 4
    echo_equals "$nequals"
    tput sgr0
    echo
}

echo_Right() {
    text=${1}
    echo
    tput cuu1
    tput cuf "$((${width} -1))"
    tput cub ${#text}
    echo "${text}"
}

echo_OK() {
    tput setaf 2
    echo_Right "[ OK ]"
    tput sgr0
}

echo_Done() {
    tput setaf 2
    echo_Right "[ Done ]"
    tput sgr0
}

echo_NotNeeded() {
    tput setaf 3
    echo_Right "[ Not Needed ]"
    tput sgr0
}

echo_Skipped() {
    tput setaf 3
    echo_Right "[ Skipped ]"
    tput sgr0
}

echo_Failed() {
    tput setaf 1
    echo_Right "[ Failed ]"
    tput sgr0
}

antwoord() {
    read -p "${1}" antwoord
        if [[ ${antwoord} == [yY] || ${antwoord} == [yY][Ee][Ss] ]]; then
            echo "yes"
        else
            echo "no"
        fi
}

StarshipOrLegacy_querry() {
    Starship="$(antwoord "Do you want to use Starship? (if not legacy will be used) ${YN}")"
}

Starship_querry() {
    InstallStarship="$(antwoord "Do you want to get Starship installed? ${YN}")"
}
Starship_install() {
    echo -n -e "Installing Starship\r"
    if [[ "${InstallStarship}" = "yes" ]]; then
        curl -sS https://starship.rs/install.sh | sh >> /dev/null 2>&1
        echo 'eval "$(starship init bash)"' >> ~/.bashrc
        echo_Done
    else
        echo_Skipped
    fi
}

StarshipConfig_querry() {
    CopyStarshipConfig="$(antwoord "Do you want to copy Starship config? ${YN}")"
}
StarshipConfig_copy() {
    echo -n -e "Copying starship.toml\r"
    if [[ "${CopyStarshipConfig}" = "yes" ]]; then
        yes | cp ./linux/starship/starship.toml ~/.config >> /dev/null 2>&1
        echo_Done
    else
        echo_Skipped
    fi
}

Bashrc_star_querry() {
    CopyStarBashrc="$(antwoord "Do you want to copy .bashrc? ${YN}")"
}
Bashrc_star_copy() {
    echo -n -e "Copying .bashrc\r"
    if [[ "${CopyStarBashrc}" = "yes" ]]; then
        yes | cp ./linux/starship/.bashrc ~/ >> /dev/null 2>&1
        echo_Done
    else
        echo_Skipped
    fi
}

Bashrc_legacy_querry() {
    CopyLegaBashrc="$(antwoord "Do you want to copy .bashrc? ${YN}")"
}
Bashrc_legacy_copy() {
    echo -n -e "Copying .bashrc\r"
    if [[ "${CopyLegaBashrc}" = "yes" ]]; then
        yes | cp ./linux/normal/.bashrc ~/ >> /dev/null 2>&1
        yes | cp ./linux/normal/.bash_functions ~/ >> /dev/null 2>&1
        echo_Done
    else
        echo_Skipped
    fi
}

Vimrc_querry() {
    CopyVimrc="$(antwoord "Do you want to copy .vimrc? ${YN}")"
}
Vimrc_copy() {
    echo -n -e "Copying .vimrc\r"
    if [[ "${CopyVimrc}" = "yes" ]]; then
        yes | cp ./linux/.vimrc ~/ >> /dev/null 2>&1
        echo_Done
    else
        echo_Skipped
    fi
}

Backup() {
    echo -n -e "Creating Backup of .bashrc\r"
    yes | cp ~/.bashrc ${backupdir} >> /dev/null 2>&1
    echo_Done
    echo -n -e "Creating Backup of .vimrc\r"
    yes | cp ~/.vimrc ${backupdir} >> /dev/null 2>&1
    echo_Done
}

# <#-------------] Main [------------#>

echo_title "Choose Options"
StarshipOrLegacy_querry
if [[ "${Starship}" = "yes" ]]; then
    echo -n -e "Starship will be used\r"
    Starship_querry
    StarshipConfig_querry
    Bashrc_star_querry
    Vimrc_querry
        
    echo_title "Prepare"

    Backup
    Starship_install
    StarshipConfig_copy
    Bashrc_star_copy
    Vimrc_copy
else
    echo -n -e "Legacy will be used\r"
    Bashrc_legacy_querry
    Vimrc_querry

    echo_title "Prepare"

    Backup
    Bashrc_legacy_copy
    Vimrc_copy
fi
echo_title "I'm done."
echo -e "\n\n"
echo "don't forget to relogin to apply the new configuration"
exit 0
