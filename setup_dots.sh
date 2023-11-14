#!/usr/bin/env bash


# <#----------] Variables [----------#>

datetime="$(date "+%Y-%m-%d-%H-%M-%S")"
logfile="/tmp/ivanti_install_${datetime}.log"
width=80
backupdir="/tmp/"

RED=$(tput setaf 1)
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

echo_Done() {
    tput setaf 2
    echo_Right "[ Done ]"
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

echo_Result() {
    retVal=$?
    if [[ "${retVal}" -ne 0 ]]; then
        echo_Failed
    else
        echo_Done
    fi
}

get_User() {
    if ! [[ $(id -u) = 0 ]]; then
        echo -e "\n ${RED}[ Error ]${NORMAL} This script must be run as root.\n"
        exit 1
    fi
}

get_Distribution() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        distribution=$NAME
        version=$VERSION_ID
        echo "Your OS seems to be $NAME $VERSION_ID"
    else
        echo -e "\nError: I need /etc/os-release to figure what distribution this is."
        exit 1
    fi
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
        curl -sS https://starship.rs/install.sh | sh >> ${logfile} 2>&1
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
        yes | cp ./linux/starship/starship.toml ~/.config >> ${logfile} 2>&1
        echo_Done
    else
        echo_Skipped
    fi
}

Bashrc_star_querry() {
    CopyStarBashrc="$(antwoord "Do you want to copy .bashrc and .bash_functions? ${YN}")"
}
Bashrc_star_copy() {
    echo -n -e "Copying .bashrc and .bash_functions\r"
    if [[ "${CopyStarBashrc}" = "yes" ]]; then
        yes | cp ./linux/starship/.bashrc ~/ >> ${logfile} 2>&1
        yes | cp ./linux/starship/.bash_functions ~/ >> ${logfile} 2>&1
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
        yes | cp ./linux/normal/.bashrc ~/ >> ${logfile} 2>&1
        yes | cp ./linux/normal/.bash_functions ~/ >> ${logfile} 2>&1
        echo_Done
    else
        echo_Skipped
    fi
}

exa_querry() {
    InstallExa="$(antwoord "Do you want to install exa? ${YN}")"
}
exa_install() {
    echo -n -e "Installing exa\r"
	if [[ "${InstallExa}" = "yes" ]]; then
		case ${distribution} in
			"Red Hat Enterprise Linux" | "Fedora" | "CentOS Linux" )
				yes | dnf install exa >> ${logfile} 2>&1
				echo_Result
				;;
			"Ubuntu" | "Debian" )
				yes | apt install exa >> ${logfile} 2>&1
				echo_Result
				;;
			* )
				echo "Unsupported distribution. Exa will not be installed!" >> ${logfile} 2>&1
				echo_Failed
				;;
		esac
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
        yes | cp ./linux/.vimrc ~/ >> ${logfile} 2>&1
        echo_Done
    else
        echo_Skipped
    fi
}

Backup() {
    echo -n -e "Creating Backup of .bashrc\r"
    yes | cp ~/.bashrc ${backupdir} >> ${logfile} 2>&1
    echo_Done
    echo -n -e "Creating Backup of .vimrc\r"
    yes | cp ~/.vimrc ${backupdir} >> ${logfile} 2>&1
    echo_Done
}

# <#-------------] Main [------------#>

get_User
get_Distribution
echo_title "Choose Options"
StarshipOrLegacy_querry
if [[ "${Starship}" = "yes" ]]; then
    echo -n -e "Starship will be used\r"
    Starship_querry
    StarshipConfig_querry
    Bashrc_star_querry
    Vimrc_querry
    exa_querry
        
    echo_title "Prepare"

    Backup
    Starship_install
    StarshipConfig_copy
    Bashrc_star_copy
    Vimrc_copy
    exa_install
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
echo -e "\n"
echo "don't forget to relogin to apply the new configuration"
echo -e "\n"
exit 0
