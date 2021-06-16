#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

## Pre-build script for LenArch, originally based on ArchCraft

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"

## Directories
DIR="$(pwd)"

## Banner
banner () {
    clear
    cat <<- _EOF_
		${GREEN}██╗     ███████╗███╗   ██╗ █████╗ ██████╗  ██████╗██╗  ██╗
██║     ██╔════╝████╗  ██║██╔══██╗██╔══██╗██╔════╝██║  ██║
██║     █████╗  ██╔██╗ ██║███████║██████╔╝██║     ███████║
██║     ██╔══╝  ██║╚██╗██║██╔══██║██╔══██╗██║     ██╔══██║
███████╗███████╗██║ ╚████║██║  ██║██║  ██║╚██████╗██║  ██║
╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
                                                          
		${CYAN}[*] ${ORANGE}By: Lena Voytek
		${CYAN}[*] ${ORANGE}Github: @lvoytek
	_EOF_
}

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}

## Script Termination
exit_on_signal_SIGINT () {
    { printf ${RED}"\n\n%s\n" "[*] Script interrupted." 2>&1; echo; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM () {
    { printf ${RED}"\n\n%s\n" "[*] Script terminated." 2>&1; echo; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Prerequisite
prerequisite() {
	{ echo; echo ${ORANGE}"[*] ${BLUE}Installing Dependencies... ${CYAN}"; echo; }
	if [[ -f /usr/bin/mkarchiso ]]; then
		{ echo ${ORANGE}"[*] ${GREEN}Dependencies are already Installed!"; }
	else
		sudo pacman -Sy archiso --noconfirm
		(type -p mkarchiso &> /dev/null) && { echo; echo "${ORANGE}[*] ${GREEN}Dependencies are succesfully installed!"; } || { echo; echo "${BLUE}[!] ${RED}Error Occured, failed to install dependencies."; echo; reset_color; exit 1; }
	fi
	{ echo; echo ${ORANGE}"[*] ${BLUE}Creating /usr/bin/mklenarchiso - ${CYAN}"; echo; }
	sudo cp -f /usr/bin/mkarchiso /usr/bin/mklenarchiso && sudo sed -i -e 's/-c -G -M/-i -c -G -M/g' /usr/bin/mklenarchiso
	{ echo; echo -e ${ORANGE}"[*] ${GREEN}'mklenarchiso' created succesfully."; echo; }
}

## Setup extra stuff
set_omz () {
	# Setup OMZ
	{ echo ${ORANGE}"[*] ${BLUE}Setting Up Oh-My-Zsh - ${CYAN}"; echo; }
	cd $DIR/iso/airootfs/etc/skel && git clone https://github.com/robbyrussell/oh-my-zsh.git --depth 1 .oh-my-zsh
	cp $DIR/iso/airootfs/etc/skel/.oh-my-zsh/templates/zshrc.zsh-template $DIR/iso/airootfs/etc/skel/.zshrc
	sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="archcraft"/g' $DIR/iso/airootfs/etc/skel/.zshrc
	# Archcraft ZSH theme
	cat > $DIR/iso/airootfs/etc/skel/.oh-my-zsh/custom/themes/archcraft.zsh-theme <<- _EOF_
		# Default OMZ theme for Archcraft

		if [[ "\$USER" == "root" ]]; then
		  PROMPT="%(?:%{\$fg_bold[red]%}%{\$fg_bold[yellow]%}%{\$fg_bold[red]%} :%{\$fg_bold[red]%} )"
		  PROMPT+='%{\$fg[cyan]%}  %c%{\$reset_color%} \$(git_prompt_info)'
		else
		  PROMPT="%(?:%{\$fg_bold[red]%}%{\$fg_bold[green]%}%{\$fg_bold[yellow]%} :%{\$fg_bold[red]%} )"
		  PROMPT+='%{\$fg[cyan]%}  %c%{\$reset_color%} \$(git_prompt_info)'
		fi

		ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[blue]%}  git:(%{\$fg[red]%}"
		ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
		ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[blue]%}) %{\$fg[yellow]%}✗"
		ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[blue]%})"
	_EOF_
	# Append some aliases
	cat >> $DIR/iso/airootfs/etc/skel/.zshrc <<- _EOF_
		# omz
		alias zshconfig="subl ~/.zshrc"
		alias ohmyzsh="thunar ~/.oh-my-zsh"

		# ls
		alias l='ls -lh'
		alias ll='ls -lah'
		alias la='ls -A'
		alias lm='ls -m'
		alias lr='ls -R'
		alias lg='ls -l --group-directories-first'

		# git
		alias gcl='git clone --depth 1'
		alias gi='git init'
		alias ga='git add'
		alias gc='git commit -m'
		alias gp='git push origin master'
	_EOF_
	{ echo; echo ${ORANGE}"[*] ${GREEN}Done. OMZ added successfully."; echo; }
}

## Changing ownership to root to avoid false permissions error
set_mod () {
	echo ${ORANGE}"[*] ${BLUE}Setting up correct permissions..."
	sudo sed -i -e 's/--no-preserve=ownership,mode/--no-preserve=ownership/g' /usr/bin/mklenarchiso
	{ echo; echo ${ORANGE}"[*] ${GREEN}Setup Completed, Change to 'iso' directory and Run './build.sh -v' as root to build the ISO."; echo; }
}

## Main
banner
prerequisite
set_omz
set_mod
exit 0
