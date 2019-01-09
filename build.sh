#!/bin/bash
#
# [Package]: blackbuntu-ce
# [Release]: Blackbuntu 18.04 CE 1.0.0
# [Website]: https://blackbuntu.org
# [Version]: CE 1.0.0
# [License]: http://www.gnu.org/licenses/gpl-3.0.html
#
# Ascii Art : https://www.askapache.com/online-tools/figlet-ascii/

#######################
## ----------------- ##
## DEFINE PARAMETERS ##
## ----------------- ##
#######################

## Colour output
## -------------
TEXT_ERROR="\033[01;31m"	# Issues/Errors
TEXT_ENDED="\033[01;32m"	# Success
TEXT_ALERT="\033[01;33m"	# Warnings/Information
TEXT_TITLE="\033[01;34m"	# Heading
TEXT_RESET="\033[00m"		# Normal

######################
## ---------------- ##
## DEFINE FUNCTIONS ##
## ---------------- ##
######################

## Display Header
## --------------
function set_banner
{
  clear
  echo -e "${TEXT_ERROR}   _     _            _    _                 _           ${TEXT_RESET}"
  echo -e "${TEXT_ERROR}  | |   | |          | |  | |               | |          ${TEXT_RESET}"
  echo -e "${TEXT_ERROR}  | |__ | | __ _  ___| | _| |__  _   _ _ __ | |_ _   _   ${TEXT_RESET}"
  echo -e "${TEXT_ERROR}  | '_ \| |/ _' |/ __| |/ / '_ \| | | | '_ \| __| | | |  ${TEXT_RESET}"
  echo -e "${TEXT_ERROR}  | |_) | | (_| | (__|   <| |_) | |_| | | | | |_| |_| |  ${TEXT_RESET}"
  echo -e "${TEXT_ERROR}  |_'__/|_|\__'_|\___|_|\_\_'__/ \__'_|_| |_|\__|\__'_|  ${TEXT_RESET}"
  echo -e "${TEXT_ERROR}                                                         ${TEXT_RESET}"
  echo -e "${TEXT_ERROR}                              Blackbuntu 18.04 CE 1.0.0  ${TEXT_RESET}"
  echo
  echo -e "${TEXT_ENDED} [i] [Package]: blackbuntu-ce${TEXT_RESET}"
  echo -e "${TEXT_ENDED} [i] [Website]: https://blackbuntu.org${TEXT_RESET}"

    echo
    sleep 3s
}

## Error file not found
## --------------------
function set_notice_404
{
	cd ~/
	echo -e "${TEXT_ERROR}[!]${TEXT_RESET} An unknown error occured ~ Remote file not found (Error 404)${TEXT_RESET}"
	echo -e "${TEXT_ERROR}[!]${TEXT_RESET} Quitting ..."
	exit 1
}

## Error DNS issues
## ----------------
function set_notice_dns
{
	cd ~/
	echo -e "${TEXT_ERROR}[!]${TEXT_RESET} An unknown error occured ~ Possible DNS issues${TEXT_RESET}"
	echo -e "${TEXT_ERROR}[!]${TEXT_RESET} Quitting ..."
	exit 1
}

## Error Notice
## ------------
function set_notice_error
{
	cd ~/
	echo -e "${TEXT_ERROR}[!] ${1^^}${TEXT_RESET}"
	sleep 1s
}

## System Package Handler
## ----------------------
function set_system_handler
{
	sudo apt -y update && sudo apt -y upgrade && sudo apt -y dist-upgrade
	sudo apt -y remove && sudo apt -y autoremove
	sudo apt -y clean && sudo apt -y autoclean
	stage_output "System updated / upgraded and cleaned successfully"
}

## Check if provided username exist
## --------------------------------
function check_username
{
	if id "$1" >/dev/null 2>&1; then
	    sleep 1s
	else
		echo -e "${TEXT_ERROR}[!]${TEXT_RESET} The username $USERNAME has not been found in the system${TEXT_RESET}"
		echo -e "${TEXT_ERROR}[!]${TEXT_RESET} Quitting ...${TEXT_RESET}"
		echo -e "\n"
		exit 1
	fi
}

## Check Internet status
## ---------------------
function check_internet
{
	for i in {1..10};
	do
		ping -c 1 -W ${i} www.google.com &>/dev/null && break;
	done

	if [[ "$?" -ne 0 ]];
	then
		set_notice_dns
	fi

	stage_output "Internet connection detected"
}

## Return stage title
## ------------------
function stage_title
{
	echo -e "\n${TEXT_TITLE}[+]${TEXT_RESET} (${1}/${2}) ${TEXT_TITLE}${3^^}${TEXT_RESET}"
	sleep 1s
}

## Return stage output
## -------------------
function stage_output
{
	cd ~/
	echo -e "${TEXT_ENDED}[i] ${1^^}${TEXT_RESET}"
	sleep 1s
}

################
## ---------- ##
## START BASH ##
## ---------- ##
################

## Display Header
## --------------
set_banner

## Get Username
## ------------
read -p " Please enter your username : " USERNAME
echo

## Stage counter start
## -------------------
STAGE=0
TOTAL=$(grep '(( STAGE++ ))' $0 | wc -l);(( TOTAL-- ))
clear

#####################################
## ------------------------------- ##
## CHECK USER LEVEL AND PERMISSION ##
## ------------------------------- ##
#####################################

## Checking Username
## -----------------
(( STAGE++ ))
stage_title $STAGE $TOTAL "Checking Username"
check_username $USERNAME
stage_output "Username checked successfully"

## Switch to Root
## --------------
(( STAGE++ ))
stage_title $STAGE $TOTAL "Switch to Root"
sudo ls -la /tmp/ >/dev/null 2>&1
stage_output "Switched to Root successfully"

#############################
## ----------------------- ##
## INSTALL NATIVE PACKAGES ##
## ----------------------- ##
#############################

## Git
## -----
(( STAGE++ ))
stage_title $STAGE $TOTAL "Installing Git"

if [ ! -f "/etc/blackbuntu/installed/ubuntu-make.txt" ];
then
  sudo apt-get install git
  sudo date +"%Y%m%d%H%M%S" | sudo tee /etc/blackbuntu/installed/git.txt >/dev/null 2>&1
fi

## Ubuntu Make
## -----
(( STAGE++ ))
stage_title $STAGE $TOTAL "Installing Ubuntu Make"

if [ ! -f "/etc/blackbuntu/installed/ubuntu-make.txt" ];
then
  sudo add-apt-repository ppa:lyzardking/ubuntu-make
  sudo apt-get update
  sudo apt-get install ubuntu-make
  sudo date +"%Y%m%d%H%M%S" | sudo tee /etc/blackbuntu/installed/ubuntu-make.txt >/dev/null 2>&1
fi
