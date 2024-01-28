#!/bin/bash
#
# FRP Wireguard Tunnel 
# Author: github.com/Azumi67
# Special thanks to github.com/opiran-club as always.
# Source: github.com/fatedier/frp
#
# This script is designed to simplify the installation and configuration of a
# Wireguard-based IPV6 tunnel using the FRP. It provides options to
# install required packages, configure the remote and local servers, and
# uninstall the configuration and Restarting Services.
#
# supported architectures: x86_64, amd64
# Supported operating systems: Tested on Ubuntu 20 - Digital Ocean
# Disclaimer:
# This script comes with no warranties or guarantees. Use it at your own risk.

# root check
if [[ $EUID -ne 0 ]]; then
  echo -e "\e[93mThis script must be run as root. Please use sudo -i.\e[0m"
  exit 1
fi
function deleteCron1() {
    entriesToDelete=(
        "0 * * * * /etc/res.sh"
        "0 */2 * * * /etc/res.sh"
        "0 */3 * * * /etc/res.sh"
        "0 */4 * * * /etc/res.sh"
        "0 */5 * * * /etc/res.sh"
        "0 */6 * * * /etc/res.sh"
        "0 */7 * * * /etc/res.sh"
        "0 */8 * * * /etc/res.sh"
        "0 */9 * * * /etc/res.sh"
        "0 */10 * * * /etc/res.sh"
        "0 */11 * * * /etc/res.sh"
        "0 */12 * * * /etc/res.sh"
        "0 */13 * * * /etc/res.sh"
        "0 */14 * * * /etc/res.sh"
        "0 */15 * * * /etc/res.sh"
        "0 */16 * * * /etc/res.sh"
        "0 */17 * * * /etc/res.sh"
        "0 */18 * * * /etc/res.sh"
        "0 */19 * * * /etc/res.sh"
        "0 */20 * * * /etc/res.sh"
        "0 */21 * * * /etc/res.sh"
        "0 */22 * * * /etc/res.sh"
        "0 */23 * * * /etc/res.sh"
    )

    existingCrontab=$(crontab -l 2>/dev/null)
    if [ -z "$existingCrontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
        return
    fi

    newCrontab="$existingCrontab"
    for entry in "${entriesToDelete[@]}"; do
        if [[ "$newCrontab" == *"$entry"* ]]; then
            newCrontab="${newCrontab//$entry/}"
        fi
    done

    if [ "$newCrontab" != "$existingCrontab" ]; then
        echo "$newCrontab" | crontab - 2>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\033[91mFailed to delete some cron entries. Don't worry about it.\033[0m"
        else
            echo -e "\033[92mDeleting Previous Crons..\033[0m"
        fi
    else
        echo -e "\033[91mCron doesn't exist, moving on..!\033[0m"
    fi
}
function deleteCron2() {
    entriesToDelete=(
		"*/1 * * * * /etc/res.sh",
		"*/2 * * * * /etc/res.sh",
		"*/3 * * * * /etc/res.sh",
		"*/4 * * * * /etc/res.sh",
		"*/5 * * * * /etc/res.sh",
		"*/6 * * * * /etc/res.sh",
		"*/7 * * * * /etc/res.sh",
		"*/8 * * * * /etc/res.sh",
		"*/9 * * * * /etc/res.sh",
		"*/10 * * * * /etc/res.sh",
		"*/11 * * * * /etc/res.sh",
		"*/12 * * * * /etc/res.sh",
		"*/13 * * * * /etc/res.sh",
		"*/14 * * * * /etc/res.sh",
		"*/15 * * * * /etc/res.sh",
		"*/16 * * * * /etc/res.sh",
		"*/17 * * * * /etc/res.sh",
		"*/18 * * * * /etc/res.sh",
		"*/19 * * * * /etc/res.sh",
		"*/20 * * * * /etc/res.sh",
		"*/21 * * * * /etc/res.sh",
		"*/22 * * * * /etc/res.sh",
		"*/23 * * * * /etc/res.sh",
		"*/24 * * * * /etc/res.sh",
		"*/25 * * * * /etc/res.sh",
		"*/26 * * * * /etc/res.sh",
		"*/27 * * * * /etc/res.sh",
		"*/28 * * * * /etc/res.sh",
		"*/29 * * * * /etc/res.sh",
		"*/30 * * * * /etc/res.sh",
		"*/31 * * * * /etc/res.sh",
		"*/32 * * * * /etc/res.sh",
		"*/33 * * * * /etc/res.sh",
		"*/34 * * * * /etc/res.sh",
		"*/35 * * * * /etc/res.sh",
		"*/36 * * * * /etc/res.sh",
		"*/37 * * * * /etc/res.sh",
		"*/38 * * * * /etc/res.sh",
		"*/39 * * * * /etc/res.sh",
		"*/40 * * * * /etc/res.sh",
		"*/41 * * * * /etc/res.sh",
		"*/42 * * * * /etc/res.sh",
		"*/43 * * * * /etc/res.sh",
		"*/44 * * * * /etc/res.sh",
		"*/45 * * * * /etc/res.sh",
		"*/46 * * * * /etc/res.sh",
		"*/47 * * * * /etc/res.sh",
		"*/48 * * * * /etc/res.sh",
		"*/49 * * * * /etc/res.sh",
		"*/50 * * * * /etc/res.sh",
		"*/51 * * * * /etc/res.sh",
		"*/52 * * * * /etc/res.sh",
		"*/53 * * * * /etc/res.sh",
		"*/54 * * * * /etc/res.sh",
		"*/55 * * * * /etc/res.sh",
		"*/56 * * * * /etc/res.sh",
		"*/57 * * * * /etc/res.sh",
		"*/58 * * * * /etc/res.sh",
		"*/59 * * * * /etc/res.sh",
    )

    existingCrontab=$(crontab -l 2>/dev/null)
    if [ -z "$existingCrontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
        return
    fi

    newCrontab="$existingCrontab"
    for entry in "${entriesToDelete[@]}"; do
        if [[ "$newCrontab" == *"$entry"* ]]; then
            newCrontab="${newCrontab//$entry/}"
        fi
    done

    if [ "$newCrontab" != "$existingCrontab" ]; then
        echo "$newCrontab" | crontab - 2>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\033[91mFailed to delete some cron entries. Don't worry about it.\033[0m"
        else
            echo -e "\033[92mDeleting Previous Crons..\033[0m"
        fi
    else
        echo -e "\033[91mCron doesn't exist, moving on..!\033[0m"
    fi
}
function deleteCron3() {
    entriesToDelete=(
        "0 * * * * /etc/resk.sh"
        "0 */2 * * * /etc/resk.sh"
        "0 */3 * * * /etc/resk.sh"
        "0 */4 * * * /etc/resk.sh"
        "0 */5 * * * /etc/resk.sh"
        "0 */6 * * * /etc/resk.sh"
        "0 */7 * * * /etc/resk.sh"
        "0 */8 * * * /etc/resk.sh"
        "0 */9 * * * /etc/resk.sh"
        "0 */10 * * * /etc/resk.sh"
        "0 */11 * * * /etc/resk.sh"
        "0 */12 * * * /etc/resk.sh"
        "0 */13 * * * /etc/resk.sh"
        "0 */14 * * * /etc/resk.sh"
        "0 */15 * * * /etc/resk.sh"
        "0 */16 * * * /etc/resk.sh"
        "0 */17 * * * /etc/resk.sh"
        "0 */18 * * * /etc/resk.sh"
        "0 */19 * * * /etc/resk.sh"
        "0 */20 * * * /etc/resk.sh"
        "0 */21 * * * /etc/resk.sh"
        "0 */22 * * * /etc/resk.sh"
        "0 */23 * * * /etc/resk.sh"
    )

    existingCrontab=$(crontab -l 2>/dev/null)
    if [ -z "$existingCrontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
        return
    fi

    newCrontab="$existingCrontab"
    for entry in "${entriesToDelete[@]}"; do
        if [[ "$newCrontab" == *"$entry"* ]]; then
            newCrontab="${newCrontab//$entry/}"
        fi
    done

    if [ "$newCrontab" != "$existingCrontab" ]; then
        echo "$newCrontab" | crontab - 2>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\033[91mFailed to delete some cron entries. Don't worry about it.\033[0m"
        else
            echo -e "\033[92mDeleting Previous Crons..\033[0m"
        fi
    else
        echo -e "\033[91mCron doesn't exist, moving on..!\033[0m"
    fi
}
function deleteCron4() {
    entriesToDelete=(
		"*/1 * * * * /etc/resk.sh",
		"*/2 * * * * /etc/resk.sh",
		"*/3 * * * * /etc/resk.sh",
		"*/4 * * * * /etc/resk.sh",
		"*/5 * * * * /etc/resk.sh",
		"*/6 * * * * /etc/resk.sh",
		"*/7 * * * * /etc/resk.sh",
		"*/8 * * * * /etc/resk.sh",
		"*/9 * * * * /etc/resk.sh",
		"*/10 * * * * /etc/resk.sh",
		"*/11 * * * * /etc/resk.sh",
		"*/12 * * * * /etc/resk.sh",
		"*/13 * * * * /etc/resk.sh",
		"*/14 * * * * /etc/resk.sh",
		"*/15 * * * * /etc/resk.sh",
		"*/16 * * * * /etc/resk.sh",
		"*/17 * * * * /etc/resk.sh",
		"*/18 * * * * /etc/resk.sh",
		"*/19 * * * * /etc/resk.sh",
		"*/20 * * * * /etc/resk.sh",
		"*/21 * * * * /etc/resk.sh",
		"*/22 * * * * /etc/resk.sh",
		"*/23 * * * * /etc/resk.sh",
		"*/24 * * * * /etc/resk.sh",
		"*/25 * * * * /etc/resk.sh",
		"*/26 * * * * /etc/resk.sh",
		"*/27 * * * * /etc/resk.sh",
		"*/28 * * * * /etc/resk.sh",
		"*/29 * * * * /etc/resk.sh",
		"*/30 * * * * /etc/resk.sh",
		"*/31 * * * * /etc/resk.sh",
		"*/32 * * * * /etc/resk.sh",
		"*/33 * * * * /etc/resk.sh",
		"*/34 * * * * /etc/resk.sh",
		"*/35 * * * * /etc/resk.sh",
		"*/36 * * * * /etc/resk.sh",
		"*/37 * * * * /etc/resk.sh",
		"*/38 * * * * /etc/resk.sh",
		"*/39 * * * * /etc/resk.sh",
		"*/40 * * * * /etc/resk.sh",
		"*/41 * * * * /etc/resk.sh",
		"*/42 * * * * /etc/resk.sh",
		"*/43 * * * * /etc/resk.sh",
		"*/44 * * * * /etc/resk.sh",
		"*/45 * * * * /etc/resk.sh",
		"*/46 * * * * /etc/resk.sh",
		"*/47 * * * * /etc/resk.sh",
		"*/48 * * * * /etc/resk.sh",
		"*/49 * * * * /etc/resk.sh",
		"*/50 * * * * /etc/resk.sh",
		"*/51 * * * * /etc/resk.sh",
		"*/52 * * * * /etc/resk.sh",
		"*/53 * * * * /etc/resk.sh",
		"*/54 * * * * /etc/resk.sh",
		"*/55 * * * * /etc/resk.sh",
		"*/56 * * * * /etc/resk.sh",
		"*/57 * * * * /etc/resk.sh",
		"*/58 * * * * /etc/resk.sh",
		"*/59 * * * * /etc/resk.sh",
    )

    existingCrontab=$(crontab -l 2>/dev/null)
    if [ -z "$existingCrontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
        return
    fi

    newCrontab="$existingCrontab"
    for entry in "${entriesToDelete[@]}"; do
        if [[ "$newCrontab" == *"$entry"* ]]; then
            newCrontab="${newCrontab//$entry/}"
        fi
    done

    if [ "$newCrontab" != "$existingCrontab" ]; then
        echo "$newCrontab" | crontab - 2>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\033[91mFailed to delete some cron entries. Don't worry about it.\033[0m"
        else
            echo -e "\033[92mDeleting Previous Crons..\033[0m"
        fi
    else
        echo -e "\033[91mCron doesn't exist, moving on..!\033[0m"
    fi
}
function deleteCron5() {
    entriesToDelete=(
        "0 * * * * /etc/resq.sh"
        "0 */2 * * * /etc/resq.sh"
        "0 */3 * * * /etc/resq.sh"
        "0 */4 * * * /etc/resq.sh"
        "0 */5 * * * /etc/resq.sh"
        "0 */6 * * * /etc/resq.sh"
        "0 */7 * * * /etc/resq.sh"
        "0 */8 * * * /etc/resq.sh"
        "0 */9 * * * /etc/resq.sh"
        "0 */10 * * * /etc/resq.sh"
        "0 */11 * * * /etc/resq.sh"
        "0 */12 * * * /etc/resq.sh"
        "0 */13 * * * /etc/resq.sh"
        "0 */14 * * * /etc/resq.sh"
        "0 */15 * * * /etc/resq.sh"
        "0 */16 * * * /etc/resq.sh"
        "0 */17 * * * /etc/resq.sh"
        "0 */18 * * * /etc/resq.sh"
        "0 */19 * * * /etc/resq.sh"
        "0 */20 * * * /etc/resq.sh"
        "0 */21 * * * /etc/resq.sh"
        "0 */22 * * * /etc/resq.sh"
        "0 */23 * * * /etc/resq.sh"
    )

    existingCrontab=$(crontab -l 2>/dev/null)
    if [ -z "$existingCrontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
        return
    fi

    newCrontab="$existingCrontab"
    for entry in "${entriesToDelete[@]}"; do
        if [[ "$newCrontab" == *"$entry"* ]]; then
            newCrontab="${newCrontab//$entry/}"
        fi
    done

    if [ "$newCrontab" != "$existingCrontab" ]; then
        echo "$newCrontab" | crontab - 2>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\033[91mFailed to delete some cron entries. Don't worry about it.\033[0m"
        else
            echo -e "\033[92mDeleting Previous Crons..\033[0m"
        fi
    else
        echo -e "\033[91mCron doesn't exist, moving on..!\033[0m"
    fi
}
function deleteCron6() {
    entriesToDelete=(
		"*/1 * * * * /etc/resq.sh",
		"*/2 * * * * /etc/resq.sh",
		"*/3 * * * * /etc/resq.sh",
		"*/4 * * * * /etc/resq.sh",
		"*/5 * * * * /etc/resq.sh",
		"*/6 * * * * /etc/resq.sh",
		"*/7 * * * * /etc/resq.sh",
		"*/8 * * * * /etc/resq.sh",
		"*/9 * * * * /etc/resq.sh",
		"*/10 * * * * /etc/resq.sh",
		"*/11 * * * * /etc/resq.sh",
		"*/12 * * * * /etc/resq.sh",
		"*/13 * * * * /etc/resq.sh",
		"*/14 * * * * /etc/resq.sh",
		"*/15 * * * * /etc/resq.sh",
		"*/16 * * * * /etc/resq.sh",
		"*/17 * * * * /etc/resq.sh",
		"*/18 * * * * /etc/resq.sh",
		"*/19 * * * * /etc/resq.sh",
		"*/20 * * * * /etc/resq.sh",
		"*/21 * * * * /etc/resq.sh",
		"*/22 * * * * /etc/resq.sh",
		"*/23 * * * * /etc/resq.sh",
		"*/24 * * * * /etc/resq.sh",
		"*/25 * * * * /etc/resq.sh",
		"*/26 * * * * /etc/resq.sh",
		"*/27 * * * * /etc/resq.sh",
		"*/28 * * * * /etc/resq.sh",
		"*/29 * * * * /etc/resq.sh",
		"*/30 * * * * /etc/resq.sh",
		"*/31 * * * * /etc/resq.sh",
		"*/32 * * * * /etc/resq.sh",
		"*/33 * * * * /etc/resq.sh",
		"*/34 * * * * /etc/resq.sh",
		"*/35 * * * * /etc/resq.sh",
		"*/36 * * * * /etc/resq.sh",
		"*/37 * * * * /etc/resq.sh",
		"*/38 * * * * /etc/resq.sh",
		"*/39 * * * * /etc/resq.sh",
		"*/40 * * * * /etc/resq.sh",
		"*/41 * * * * /etc/resq.sh",
		"*/42 * * * * /etc/resq.sh",
		"*/43 * * * * /etc/resq.sh",
		"*/44 * * * * /etc/resq.sh",
		"*/45 * * * * /etc/resq.sh",
		"*/46 * * * * /etc/resq.sh",
		"*/47 * * * * /etc/resq.sh",
		"*/48 * * * * /etc/resq.sh",
		"*/49 * * * * /etc/resq.sh",
		"*/50 * * * * /etc/resq.sh",
		"*/51 * * * * /etc/resq.sh",
		"*/52 * * * * /etc/resq.sh",
		"*/53 * * * * /etc/resq.sh",
		"*/54 * * * * /etc/resq.sh",
		"*/55 * * * * /etc/resq.sh",
		"*/56 * * * * /etc/resq.sh",
		"*/57 * * * * /etc/resq.sh",
		"*/58 * * * * /etc/resq.sh",
		"*/59 * * * * /etc/resq.sh",
    )

    existingCrontab=$(crontab -l 2>/dev/null)
    if [ -z "$existingCrontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
        return
    fi

    newCrontab="$existingCrontab"
    for entry in "${entriesToDelete[@]}"; do
        if [[ "$newCrontab" == *"$entry"* ]]; then
            newCrontab="${newCrontab//$entry/}"
        fi
    done

    if [ "$newCrontab" != "$existingCrontab" ]; then
        echo "$newCrontab" | crontab - 2>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\033[91mFailed to delete some cron entries. Don't worry about it.\033[0m"
        else
            echo -e "\033[92mDeleting Previous Crons..\033[0m"
        fi
    else
        echo -e "\033[91mCron doesn't exist, moving on..!\033[0m"
    fi
}
# bar
function display_progress() {
  local total=$1
  local current=$2
  local width=40
  local percentage=$((current * 100 / total))
  local completed=$((width * current / total))
  local remaining=$((width - completed))

  printf '\r['
  printf '%*s' "$completed" | tr ' ' '='
  printf '>'
  printf '%*s' "$remaining" | tr ' ' ' '
  printf '] %d%%' "$percentage"
}

# baraye checkmark
function display_checkmark() {
  echo -e "\xE2\x9C\x94 $1"
}

# error msg
function display_error() {
  echo -e "\xE2\x9D\x8C Error: $1"
}

# notify
function display_notification() {
  echo -e "\xE2\x9C\xA8 $1"
}
# Azumi is in your area
function display_loading() {
  local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  local delay=0.1
  local duration=3  # Duration in seconds

  local end_time=$((SECONDS + duration))

  while ((SECONDS < end_time)); do
    for frame in "${frames[@]}"; do
      printf "\r[frame] Loading...  "
      sleep "$delay"
      printf "\r[frame]             "
      sleep "$delay"
    done
  done

  echo -e "\r\xE2\x98\xBA Service activated successfully! ~"
}

#logo
function display_logo() {
echo -e "\033[1;96m$logo\033[0m"
}
# art
logo=$(cat << "EOF"
\033[1;96m          
                 
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠀⢀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠀⡀⠤⠒⠊⠉⠀⠀⠀⠀⠈⠁⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀\033[1;93m⠀⢀⠔⠉⠀⠀⠀⠀⢀⡠⠤⠐⠒⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠀⣀⡠⠤⠤⠀⠀⠂⠐\033[1;96m⠀⠠⢤⠎⢑⡭⣽⣳⠶⣖⡶⣤⣖⣬⡽⡭⣥⣄\033[1;93m⠒⠒⠀⠐⠁⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⢀⠴⠊⠁⠀⠀⠀⠀⡀⠀\033[1;96m⣠⣴⡶⣿⢏⡿⣝⡳⢧⡻⣟⡻⣞⠿⣾⡽⣳⣯⣳⣞⡻⣦⡀⠀⠀\033[1;93m⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⢨⠀⠀⠀⢀⠤⠂⠁\033[1;96m⢠⣾⡟⣧⠿⣝⣮⣽⢺⣝⣳⡽⣎⢷⣫⡟⡵⡿⣵⢫⡷⣾⢷⣭⢻⣦⡄\033[1;93m⠤⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠘⡄⠀⠀⠓⠂⠀\033[1;96m⣴⣿⢷⡿⣝⣻⣏⡷⣾⣟⡼⣣⢟⣼⣣⢟⣯⢗⣻⣽⣏⡾⡽⣟⣧⠿⡼⣿⣦\033[1;93m⣃⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⢀⠇⠀⠀⠀⠀\033[1;96m⣼⣿⢿⣼⡻⣼⡟⣼⣧⢿⣿⣸⡧⠿⠃⢿⣜⣻⢿⣤⣛⣿⢧⣻⢻⢿⡿⢧⣛⣿⣧⠀\033[1;93m⠛⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⢸⠁⠀⠀⠀⠀\033[1;96m⣼⣻⡿⣾⣳⡽⣾⣽⡷⣻⣞⢿⣫⠕⣫⣫⣸⢮⣝⡇⠱⣏⣾⣻⡽⣻⣮⣿⣻⡜⣞⡿⣷\033[1;93m⢀⠀⠀⠑⠢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠘⣧⠀⠀⠀\033[1;96m⣼⣳⢯⣿⣗⣿⣏⣿⠆⣟⣿⣵⢛⣵⡿⣿⣏⣟⡾⣜⣻⠀⢻⡖⣷⢳⣏⡶⣻⡧⣟⡼⣻⡽⣇\033[1;93m⠁⠢⡀⠠⡀⠑⡄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠈⢦⠀\033[1;96m⣰⣯⣟⢯⣿⢾⣹⢾⡟⠰⣏⡾⣾⣟⡷⣿⣻⣽⣷⡶⣟⠿⡆⠀⢻⣝⣯⢷⣹⢧⣿⢧⡻⣽⣳⢽⡀\033[1;93m⠀⠈⠀⠈⠂⡼⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠀⡀⢵\033[1;96m⣟⣾⡟⣾⣿⣻⢽⣺⠇⠀⣿⡱⢿⡞⣵⡳⣭⣿⡜⣿⣭⣻⣷⠲⠤⢿⣾⢯⢯⣛⢿⣳⡝⣾⣿⢭⡇⠀\033[1;93m⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⢀⠤⠊⠀\033[1;96m⣼⢻⣿⢞⣯⢿⡽⣸⣹⡆⠀⢷⣏⢯⣿⣧⣛⠶⣯⢿⣽⣷⣧⣛⣦⠀⠀⠙⢿⣳⣽⣿⣣⢟⡶⣿⣫⡇⠀⠀\033[1;93m⠀⠰⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⣠⠖⠁⠀⠀⡄\033[1;96m⡿⣯⣷⣻⡽⣞⡟⣿⣿⣟⠉⠈⢯⣗⣻⣕⢯⣛⡞⣯⢮⣷⣭⡚⠓⠋⠀⠀⠀⠈⠉⣿⡽⣎⠷⡏⡷⣷⠀⠀⠀\033[1;93m⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠐⣇⠀⠀⢀⠊\033[1;96m⣼⣇⣿⡗⣿⣽⣷⡿⣿⣱⡿⣆⠀⠀⠙⠒⠛⠓⠋⠉⠉⠀⠀⠀\033[1;91m⢠⣴⣯⣶⣶⣤⡀\033[1;96m ⠀⣿⣟⡼⣛⡇⣟⣿⡆\033[1;93m⡀⠀⢀⠇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠘⢤⠀⠃⠌\033[1;96m⣸⣿⢾⡽⣹⣾⠹⣞⡵⣳⣽⡽⣖⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[1;91m⣤⣖⣻⣾⣝⢿⡄\033[1;96m ⢸⣯⢳⣏⡿⣏⣾⢧\033[1;93m⠈⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠘⠀⠈⠀\033[1;96m⡿⣿⣻⡽⣽⣿⢧⠌⠉\033[1;91m⠉⣴⣿⣿⣫⣅⡀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣛⠿⠿⢟⢙⡄⠙\033[1;96m ⠘⣯⢳⣞⡟⣯⢾⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⡇⠀⠀⠀\033[1;96m⡿⣿⣿⢵⣫⣿⣆⠁⠂\033[1;91m⣼⡿⢹⣿⡿⠽⠟⢢⠀⠀⠀⠀⠀⠀⠀⢹⠀⢄⢀⠀⡿⠀⠀\033[1;96m ⢰⣯⢷⣺⣏⣯⢻⡽⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⡇⠀⢀⠠\033[1;96m⣿⣿⢾⣛⡶⣽⠈⢓⠀\033[1;91m⢻⠁⢸⠇⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠑⠠⠤⠔⠂⠀⠀\033[1;96m ⢸⣿⢮⣽⠿⣜⣻⡝⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀\033[1;93m⠀⠑⠊⠁\033[1;96m⢠⡷⡇⣿⣿⢼⣹⡀⠀⠑⢄⠀\033[1;91m⠀⠃⠌⣁⠦⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠂⠀⠀\033[1;96m⢀⣿⢾⡝⣾⡽⣺⢽⣹⣽⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣻⢽⣻⡟⣮⣝⡷⢦⣄⣄⣢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣯⢿⡺⣟⢷⡹⢾⣷⡞⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣟⡿⣎⢿⡽⣳⢮⣿⣹⣾⣯⡝⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⣀⣴⡟⣿⢧⣏⢷⡟⣮⠝⢿⣹⣯⡽⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣯⡷⣏⣾⡳⣽⢺⣷⡹⣟⢶⡹⣾⡽⣷⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠔⣾⢯⣷⡇⣿⢳⣎⢿⡞⣽⢦⣼⡽⣧⢻⡽⣆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣟⢾⡷⣭⣿⢳⣭⢻⣷⡻⣜⣻⡵⣻⡼⣿⠾⠫\033[1;96m⣽⣟⣶⣶⣶⠒⠒⠂⠉⠀\033[1;96m⢸⣽⢺⡷⣷⣯⢗⣮⣟⢾⢧⣻⠼⡿⣿⢣⡟⣼⣆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⣝⣾⢳⢧⣟⡳⣎⣿⣿⣱⢏⣾⣽⣳⠟\033[1;92m⠁⠀⡌⠈\033[1;96m⢹⡯⠟⠛⠀⠀⠀⠀⠀⠈\033[1;96m⣷⢻⣼⣽⣿⡾⣼⣏⣾⣻⡜⣯⣷⢿⣟⣼⡳⣞⣦⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⢿⡸⣎⠿⣾⡏⣷⣉⣷⣿⢹⣎⡿\033[1;92m⠎⡎⠀⠀⠀⡇⠀⣾⠱⡀⠀⠀⠀⠀⠀⠀⠀⠈⣹⠉⡏⠀\033[1;96m⠹⣾⣏⢹⣶⢹⣶⢿⡾⣿⢶⣿⣸⠾⣇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⣾⢫⣞⡽⣯⢿⣹⡟⣶⣹⢷⣻\033[1;92m⡷⠊⠀⡜⠀⠀⠀⠀⢱⠀⣿⡀⠈⠢⢀⣀⣀⠠⠄⠒⢈⡏⡰⠀⠀⠀\033[1;96m⠀⣿⡜⣮⢟⡼⣻⡵⣻⣗⠾⣟⣯⢻⣆⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣴⣿⢣⣟⡾⣽⣯⢳⣿⡹⣖⣿⡳\033[1;92m⠋⠀⠀⡸⠀⠀⠀⠀⠀⢸⠀⢺⢂⠀⠀⠀⠀⠀⠀⠀⢠⡺⡱⠁⠀⠀⠀⠀\033[1;96m⢹⣧⣻⢮⡳⣝⡷⢧⣻⢯⢿⣻⣳⢞⡆⠀⠀⠀
⠀⠀⠀⠀⢀⡾⣽⣣⡿⣼⣏⡿⣼⣳⡯⢷⣹⣯⠇\033[1;92m⠀⠀⢠⠁⠀⠀⠀⠀⠀⠈⡆⠈⢹⡰⠤⡀⠀⠀⠀⢠⡼⢱⠁⠀⠀⠀⠀⠀⠀\033[1;96m⠹⣿⣿⣱⣻⣼⣏⢷⣯⣿⡳⣿⣎⢿⡀⠀⠀
⠀⠀⠀⠀⣾⣽⠷⣿⣵⡿⣼⡟⣭⣷⡟⣿⢯⡏⠀\033[1;92m⠀⠀⠘⠀⠀⠒⠈⢡⠀⠀⢗⢄⠀⠃⠀⠺⢁⢈⠥⠋⣀⠇⠀⠀⠀⠀⠀⠀⡀⠀\033[1;96m⠈⠙⢿⣳⢞⣽⢯⣞⣾⣯⡝⣿⡾⡇⠀⠀\033[1;92mAuthor: github.com/Azumi67  \033[1;96m ⠀⠀⠀⠀
  \033[1;96m  ______   \033[1;94m _______  \033[1;92m __    \033[1;93m  _______     \033[1;91m   __      \033[1;96m _____  ___  
 \033[1;96m  /    " \  \033[1;94m|   __ "\ \033[1;92m|" \  \033[1;93m  /"      \    \033[1;91m  /""\     \033[1;96m(\"   \|"  \ 
 \033[1;96m // ____  \ \033[1;94m(. |__) :)\033[1;92m||  |  \033[1;93m|:        |   \033[1;91m /    \   \033[1;96m |.\\   \     |
 \033[1;96m/  /    ) :)\033[1;94m|:  ____/ \033[1;92m|:  |  \033[1;93m|_____/   )  \033[1;91m /' /\  \   \033[1;96m|: \.   \\   |
\033[1;96m(: (____/ // \033[1;94m(|  /     \033[1;92m|.  |  \033[1;93m //      /  \033[1;91m //  __'  \  \033[1;96m|.  \    \  |
 \033[1;96m\        / \033[1;94m/|__/ \    \033[1;92m/\  |\ \033[1;93m|:  __   \  \033[1;91m/   /  \\   \ \033[1;96m|    \    \ |
 \033[1;96m \"_____/ \033[1;94m(_______)  \033[1;92m(__\_|_)\033[1;93m|__|  \___)\033[1;91m(___/    \___) \033[1;96m\___|\____\)
EOF
)


function rmve_cron() {
    entries_to_remove=(
        "0 */2 * * * /etc/res.sh"
    )

    if test -f /etc/res.sh; then
        for entry in "${entries_to_remove[@]}"; do
            existing_crontab=$(crontab -l 2>/dev/null)
            if [[ $existing_crontab == *"$entry"* ]]; then
                modified_crontab=${existing_crontab//$entry/}
                echo "$modified_crontab" | crontab -
                echo -e "\033[92mCron entry removed!\033[0m"
                rm /etc/res.sh
                return
            fi
        done
        echo -e "\033[91mCron entry not found.\033[0m"
    else
        echo -e "\033[91m/etc/res.sh file not found.\033[0m"
    fi
}

timez() {
    clear
    echo -e '\033[92m ^ ^\033[0m'
    echo -e '\033[92m(\033[91mO,O\033[92m)\033[0m'
    echo -e '\033[92m(   ) \033[96mReset Timer\033[0m'
    echo -e '\033[92m "-"\033[93m════════════════════════════════════\033[0m'
    echo -e "\033[93m───────────────────────────────────────\033[0m"
    echo -e '1. \033[93mHour \033[0m'
    echo -e '2. \033[92mMinutes \033[0m'
    echo -e '0. \033[34mBack to main menu \033[0m'
    echo -e "\033[93m───────────────────────────────────────\033[0m"

    while true; do
        read -e -p $'\033[38;5;205mEnter your choice Please: \033[0m' server_type
        if [[ "$server_type" == "1" ]]; then
            timerhour
            break
        elif [[ "$server_type" == "2" ]]; then
            timermins
            break
        elif [[ "$server_type" == "0" ]]; then
            clear
            main_menu
            break
        else
            echo 'Invalid choice.'
        fi
    done
}

timermins() {
    clear
    echo -e '\033[92m ^ ^\033[0m'
    echo -e '\033[92m(\033[91mO,O\033[92m)\033[0m'
    echo -e '\033[92m(   ) \033[96mReset Timer based on minutes\033[0m'
    echo -e '\033[92m "-"\033[93m════════════════════════════════════\033[0m'
    echo -e "\033[93m───────────────────────────────────────\033[0m"
    echo -e '1. \033[93mSimple UDP \033[0m'
    echo -e '2. \033[96mKCP + UDP\033[0m'
	echo -e '3. \033[92mQuic + UDP\033[0m'
    echo -e '0. \033[34mBack to previous menu \033[0m'
    echo -e "\033[93m───────────────────────────────────────\033[0m"

    while true; do
        read -e -p $'\033[38;5;205mEnter your choice Please: \033[0m' server_type
        if [[ "$server_type" == "1" ]]; then
            minutesu
            break
        elif [[ "$server_type" == "2" ]]; then
            minutesk
            break
        elif [[ "$server_type" == "3" ]]; then
            minutesq
            break
        elif [[ "$server_type" == "0" ]]; then
            clear
            timez
            break
        else
            echo 'Invalid choice.'
        fi
    done
}
minutesq() {
    deleteCron5
	deleteCron6
    read -e -p $'\033[93mEnter the \033[92mReset Timer\033[93m [in minutes]:\033[0m ' minutes

    cron_entry="*/$minutes * * * * /etc/resq.sh"

    existing_crontab=""
    existing_crontab=$(crontab -l 2>/dev/null)

    if [ -z "$existing_crontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
    fi

    new_crontab=$(echo "$existing_crontab" | grep -v "/etc/resq.sh")
    new_crontab="$new_crontab"$'\n'"$cron_entry"

    if echo "$new_crontab" | crontab -; then
        display_checkmark "\033[92mCron entry added successfully!\033[0m"
    else
        display_error "Failed to add cron entry."
    fi
}
minutesk() {
    deleteCron3
	deleteCron4
    read -e -p $'\033[93mEnter the \033[92mReset Timer\033[93m [in minutes]:\033[0m ' minutes

    cron_entry="*/$minutes * * * * /etc/resk.sh"

    existing_crontab=""
    existing_crontab=$(crontab -l 2>/dev/null)

    if [ -z "$existing_crontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
    fi

    new_crontab=$(echo "$existing_crontab" | grep -v "/etc/resk.sh")
    new_crontab="$new_crontab"$'\n'"$cron_entry"

    if echo "$new_crontab" | crontab -; then
        display_checkmark "\033[92mCron entry added successfully!\033[0m"
    else
        display_error "Failed to add cron entry."
    fi
}
minutesu() {
    deleteCron1
	deleteCron2
    read -e -p $'\033[93mEnter the \033[92mReset Timer\033[93m [in minutes]:\033[0m ' minutes

    cron_entry="*/$minutes * * * * /etc/res.sh"

    existing_crontab=""
    existing_crontab=$(crontab -l 2>/dev/null)

    if [ -z "$existing_crontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
    fi

    new_crontab=$(echo "$existing_crontab" | grep -v "/etc/res.sh")
    new_crontab="$new_crontab"$'\n'"$cron_entry"

    if echo "$new_crontab" | crontab -; then
        display_checkmark "\033[92mCron entry added successfully!\033[0m"
    else
        display_error "Failed to add cron entry."
    fi
}
timerhour() {
    clear
    echo -e '\033[92m ^ ^\033[0m'
    echo -e '\033[92m(\033[91mO,O\033[92m)\033[0m'
    echo -e '\033[92m(   ) \033[96mReset Timer based on hours\033[0m'
    echo -e '\033[92m "-"\033[93m════════════════════════════════════\033[0m'
    echo -e "\033[93m───────────────────────────────────────\033[0m"
    echo -e '1. \033[93mSimple UDP \033[0m'
    echo -e '2. \033[96mKCP + UDP\033[0m'
	echo -e '3. \033[92mQuic + UDP\033[0m'
    echo -e '0. \033[34mBack to previous menu \033[0m'
    echo -e "\033[93m───────────────────────────────────────\033[0m"

    while true; do
        read -e -p $'\033[38;5;205mEnter your choice Please: \033[0m' server_type
        if [[ "$server_type" == "1" ]]; then
            houru
            break
        elif [[ "$server_type" == "2" ]]; then
            hourk
            break
        elif [[ "$server_type" == "3" ]]; then
            hourq
            break
        elif [[ "$server_type" == "0" ]]; then
            clear
            timez
            break
        else
            echo 'Invalid choice.'
        fi
    done
}
hourq() {
    deleteCron5
	deleteCron6
    read -e -p $'\033[93mEnter the \033[92mReset Timer\033[93m [in hours]:\033[0m ' hours

    if [[ "$hours" == "1" ]]; then
        cron_entry="0 * * * * /etc/resq.sh"
    else
        cron_entry="0 */$hours * * * /etc/resq.sh"
    fi

    existing_crontab=""
    existing_crontab=$(crontab -l 2>/dev/null)

    if [ -z "$existing_crontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
    fi

    new_crontab=$(echo "$existing_crontab" | grep -v "/etc/resq.sh")
    new_crontab="$new_crontab"$'\n'"$cron_entry"

    if echo "$new_crontab" | crontab -; then
        display_checkmark "\033[92mCron entry added successfully!\033[0m"
    else
        display_error "Failed to add cron entry."
    fi
}
hourk() {
    deleteCron3
	deleteCron4
    read -e -p $'\033[93mEnter the \033[92mReset Timer\033[93m [in hours]:\033[0m ' hours

    if [[ "$hours" == "1" ]]; then
        cron_entry="0 * * * * /etc/resk.sh"
    else
        cron_entry="0 */$hours * * * /etc/resk.sh"
    fi

    existing_crontab=""
    existing_crontab=$(crontab -l 2>/dev/null)

    if [ -z "$existing_crontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
    fi

    new_crontab=$(echo "$existing_crontab" | grep -v "/etc/resk.sh")
    new_crontab="$new_crontab"$'\n'"$cron_entry"

    if echo "$new_crontab" | crontab -; then
        display_checkmark "\033[92mCron entry added successfully!\033[0m"
    else
        display_error "Failed to add cron entry."
    fi
}
houru() {
    deleteCron1
	deleteCron2
    read -e -p $'\033[93mEnter the \033[92mReset Timer\033[93m [in hours]:\033[0m ' hours

    if [[ "$hours" == "1" ]]; then
        cron_entry="0 * * * * /etc/res.sh"
    else
        cron_entry="0 */$hours * * * /etc/res.sh"
    fi

    existing_crontab=""
    existing_crontab=$(crontab -l 2>/dev/null)

    if [ -z "$existing_crontab" ]; then
        echo -e "\033[91mNo existing cron found!\033[0m"
    fi

    new_crontab=$(echo "$existing_crontab" | grep -v "/etc/res.sh")
    new_crontab="$new_crontab"$'\n'"$cron_entry"

    if echo "$new_crontab" | crontab -; then
        display_checkmark "\033[92mCron entry added successfully!\033[0m"
    else
        display_error "Failed to add cron entry."
    fi
}


res_li() {
    deleteCron1
    deleteCron2

    if [[ -f "/etc/res.sh" ]]; then
        rm "/etc/res.sh"
    fi

    cat << 'EOF' > "/etc/res.sh"
#!/bin/bash
kill -9 \$(pgrep frps)
systemctl daemon-reload
systemctl restart azumifrps
sudo journalctl --vacuum-size=1M
EOF

    chmod +x "/etc/res.sh"

    echo "╭──────────────────────────────────────╮"
    echo "Choose an option:"
    echo -e "1. \033[93mReset timer \033[92m(hours)\033[0m"
    echo -e "2. \033[93mReset timer \033[92m(minutes)\033[0m"
    echo ""
    echo -n "Choose your number: "
    read -r optionStr
    optionStr=$(echo "${optionStr}" | tr -d ' ')

    echo "╰──────────────────────────────────────╯"

    if [[ ! "${optionStr}" =~ ^[12]$ ]]; then
        echo -e "\033[91mInvalid input for option:\033[0m ${optionStr}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        timeUnit="hours"
    elif [[ "${optionStr}" == "2" ]]; then
        timeUnit="minutes"
    fi

    echo -e -n "\033[93mEnter reset time (${timeUnit}): \033[0m"
    read -r timeStr
    timeStr=$(echo "${timeStr}" | tr -d ' ')

    timeValue=$(echo "${timeStr}" | awk '{print $1+0}')
    if [[ ! "${timeValue}" =~ ^[0-9]+$ ]]; then
        echo -e "\033[91mInvalid input for reset time:\033[0m ${timeValue}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        if [[ "${timeValue}" == "1" ]]; then
            cronEntry="0 * * * * /etc/res.sh"
        elif [[ "${timeValue}" -ge 2 ]]; then
            cronEntry="0 */${timeValue} * * * /etc/res.sh"
        fi
    elif [[ "${optionStr}" == "2" ]]; then
        cronEntry="*/${timeValue} * * * * /etc/res.sh"
    fi

    if crontab -l | grep -qF "${cronEntry}"; then
        echo -e "\033[92mOh... Cron entry already exists!\033[0m"
        exit 0
    fi

    (crontab -l ; echo "${cronEntry}") | crontab -

    echo -e "\033[92mCron entry added successfully!\033[0m"
}
res_lk() {
    deleteCron1
    deleteCron2

    if [[ -f "/etc/res.sh" ]]; then
        rm "/etc/res.sh"
    fi

    cat << 'EOF' > "/etc/res.sh"
#!/bin/bash
kill -9 \$(pgrep frpc)
systemctl daemon-reload
systemctl restart azumifrpc
sudo journalctl --vacuum-size=1M
EOF

    chmod +x "/etc/res.sh"

    echo "╭──────────────────────────────────────╮"
    echo "Choose an option:"
    echo -e "1. \033[93mReset timer \033[92m(hours)\033[0m"
    echo -e "2. \033[93mReset timer \033[92m(minutes)\033[0m"
    echo ""
    echo -n "Choose your number: "
    read -r optionStr
    optionStr=$(echo "${optionStr}" | tr -d ' ')

    echo "╰──────────────────────────────────────╯"

    if [[ ! "${optionStr}" =~ ^[12]$ ]]; then
        echo -e "\033[91mInvalid input for option:\033[0m ${optionStr}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        timeUnit="hours"
    elif [[ "${optionStr}" == "2" ]]; then
        timeUnit="minutes"
    fi

    echo -e -n "\033[93mEnter reset time (${timeUnit}): \033[0m"
    read -r timeStr
    timeStr=$(echo "${timeStr}" | tr -d ' ')

    timeValue=$(echo "${timeStr}" | awk '{print $1+0}')
    if [[ ! "${timeValue}" =~ ^[0-9]+$ ]]; then
        echo -e "\033[91mInvalid input for reset time:\033[0m ${timeValue}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        if [[ "${timeValue}" == "1" ]]; then
            cronEntry="0 * * * * /etc/res.sh"
        elif [[ "${timeValue}" -ge 2 ]]; then
            cronEntry="0 */${timeValue} * * * /etc/res.sh"
        fi
    elif [[ "${optionStr}" == "2" ]]; then
        cronEntry="*/${timeValue} * * * * /etc/res.sh"
    fi

    if crontab -l | grep -qF "${cronEntry}"; then
        echo -e "\033[92mOh... Cron entry already exists!\033[0m"
        exit 0
    fi

    (crontab -l ; echo "${cronEntry}") | crontab -

    echo -e "\033[92mCron entry added successfully!\033[0m"
}
res_kcpk() {
    deleteCron3
    deleteCron4

    if [[ -f "/etc/resk.sh" ]]; then
        rm "/etc/resk.sh"
    fi

    cat << 'EOF' > "/etc/resk.sh"
#!/bin/bash
kill -9 \$(pgrep frpc)
systemctl daemon-reload
systemctl restart azumikcpc
sudo journalctl --vacuum-size=1M
EOF

    chmod +x "/etc/resk.sh"

    echo "╭──────────────────────────────────────╮"
    echo "Choose an option:"
    echo -e "1. \033[93mReset timer \033[92m(hours)\033[0m"
    echo -e "2. \033[93mReset timer \033[92m(minutes)\033[0m"
    echo ""
    echo -n "Choose your number: "
    read -r optionStr
    optionStr=$(echo "${optionStr}" | tr -d ' ')

    echo "╰──────────────────────────────────────╯"

    if [[ ! "${optionStr}" =~ ^[12]$ ]]; then
        echo -e "\033[91mInvalid input for option:\033[0m ${optionStr}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        timeUnit="hours"
    elif [[ "${optionStr}" == "2" ]]; then
        timeUnit="minutes"
    fi

    echo -e -n "\033[93mEnter reset time (${timeUnit}): \033[0m"
    read -r timeStr
    timeStr=$(echo "${timeStr}" | tr -d ' ')

    timeValue=$(echo "${timeStr}" | awk '{print $1+0}')
    if [[ ! "${timeValue}" =~ ^[0-9]+$ ]]; then
        echo -e "\033[91mInvalid input for reset time:\033[0m ${timeValue}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        if [[ "${timeValue}" == "1" ]]; then
            cronEntry="0 * * * * /etc/resk.sh"
        elif [[ "${timeValue}" -ge 2 ]]; then
            cronEntry="0 */${timeValue} * * * /etc/resk.sh"
        fi
    elif [[ "${optionStr}" == "2" ]]; then
        cronEntry="*/${timeValue} * * * * /etc/resk.sh"
    fi

    if crontab -l | grep -qF "${cronEntry}"; then
        echo -e "\033[92mOh... Cron entry already exists!\033[0m"
        exit 0
    fi

    (crontab -l ; echo "${cronEntry}") | crontab -

    echo -e "\033[92mCron entry added successfully!\033[0m"
}
res_kcpi() {
    deleteCron3
    deleteCron4

    if [[ -f "/etc/resk.sh" ]]; then
        rm "/etc/resk.sh"
    fi

    cat << 'EOF' > "/etc/resk.sh"
#!/bin/bash
kill -9 \$(pgrep frps)
systemctl daemon-reload
systemctl restart azumikcps
sudo journalctl --vacuum-size=1M
EOF

    chmod +x "/etc/resk.sh"

    echo "╭──────────────────────────────────────╮"
    echo "Choose an option:"
    echo -e "1. \033[93mReset timer \033[92m(hours)\033[0m"
    echo -e "2. \033[93mReset timer \033[92m(minutes)\033[0m"
    echo ""
    echo -n "Choose your number: "
    read -r optionStr
    optionStr=$(echo "${optionStr}" | tr -d ' ')

    echo "╰──────────────────────────────────────╯"

    if [[ ! "${optionStr}" =~ ^[12]$ ]]; then
        echo -e "\033[91mInvalid input for option:\033[0m ${optionStr}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        timeUnit="hours"
    elif [[ "${optionStr}" == "2" ]]; then
        timeUnit="minutes"
    fi

    echo -e -n "\033[93mEnter reset time (${timeUnit}): \033[0m"
    read -r timeStr
    timeStr=$(echo "${timeStr}" | tr -d ' ')

    timeValue=$(echo "${timeStr}" | awk '{print $1+0}')
    if [[ ! "${timeValue}" =~ ^[0-9]+$ ]]; then
        echo -e "\033[91mInvalid input for reset time:\033[0m ${timeValue}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        if [[ "${timeValue}" == "1" ]]; then
            cronEntry="0 * * * * /etc/resk.sh"
        elif [[ "${timeValue}" -ge 2 ]]; then
            cronEntry="0 */${timeValue} * * * /etc/resk.sh"
        fi
    elif [[ "${optionStr}" == "2" ]]; then
        cronEntry="*/${timeValue} * * * * /etc/resk.sh"
    fi

    if crontab -l | grep -qF "${cronEntry}"; then
        echo -e "\033[92mOh... Cron entry already exists!\033[0m"
        exit 0
    fi

    (crontab -l ; echo "${cronEntry}") | crontab -

    echo -e "\033[92mCron entry added successfully!\033[0m"
}
res_quick() {
    deleteCron5
    deleteCron6

    if [[ -f "/etc/resq.sh" ]]; then
        rm "/etc/resq.sh"
    fi

    cat << 'EOF' > "/etc/resq.sh"
#!/bin/bash
kill -9 \$(pgrep frpc)
systemctl daemon-reload
systemctl restart azumiquicc
sudo journalctl --vacuum-size=1M
EOF

    chmod +x "/etc/resq.sh"

    echo "╭──────────────────────────────────────╮"
    echo "Choose an option:"
    echo -e "1. \033[93mReset timer \033[92m(hours)\033[0m"
    echo -e "2. \033[93mReset timer \033[92m(minutes)\033[0m"
    echo ""
    echo -n "Choose your number: "
    read -r optionStr
    optionStr=$(echo "${optionStr}" | tr -d ' ')

    echo "╰──────────────────────────────────────╯"

    if [[ ! "${optionStr}" =~ ^[12]$ ]]; then
        echo -e "\033[91mInvalid input for option:\033[0m ${optionStr}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        timeUnit="hours"
    elif [[ "${optionStr}" == "2" ]]; then
        timeUnit="minutes"
    fi

    echo -e -n "\033[93mEnter reset time (${timeUnit}): \033[0m"
    read -r timeStr
    timeStr=$(echo "${timeStr}" | tr -d ' ')

    timeValue=$(echo "${timeStr}" | awk '{print $1+0}')
    if [[ ! "${timeValue}" =~ ^[0-9]+$ ]]; then
        echo -e "\033[91mInvalid input for reset time:\033[0m ${timeValue}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        if [[ "${timeValue}" == "1" ]]; then
            cronEntry="0 * * * * /etc/resq.sh"
        elif [[ "${timeValue}" -ge 2 ]]; then
            cronEntry="0 */${timeValue} * * * /etc/resq.sh"
        fi
    elif [[ "${optionStr}" == "2" ]]; then
        cronEntry="*/${timeValue} * * * * /etc/resq.sh"
    fi

    if crontab -l | grep -qF "${cronEntry}"; then
        echo -e "\033[92mOh... Cron entry already exists!\033[0m"
        exit 0
    fi

    (crontab -l ; echo "${cronEntry}") | crontab -

    echo -e "\033[92mCron entry added successfully!\033[0m"
}
res_quici() {
    deleteCron5
    deleteCron6

    if [[ -f "/etc/resq.sh" ]]; then
        rm "/etc/resq.sh"
    fi

    cat << 'EOF' > "/etc/resq.sh"
#!/bin/bash
kill -9 \$(pgrep frps)
systemctl daemon-reload
systemctl restart azumiquics
sudo journalctl --vacuum-size=1M
EOF

    chmod +x "/etc/resq.sh"

    echo "╭──────────────────────────────────────╮"
    echo "Choose an option:"
    echo -e "1. \033[93mReset timer \033[92m(hours)\033[0m"
    echo -e "2. \033[93mReset timer \033[92m(minutes)\033[0m"
    echo ""
    echo -n "Choose your number: "
    read -r optionStr
    optionStr=$(echo "${optionStr}" | tr -d ' ')

    echo "╰──────────────────────────────────────╯"

    if [[ ! "${optionStr}" =~ ^[12]$ ]]; then
        echo -e "\033[91mInvalid input for option:\033[0m ${optionStr}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        timeUnit="hours"
    elif [[ "${optionStr}" == "2" ]]; then
        timeUnit="minutes"
    fi

    echo -e -n "\033[93mEnter reset time (${timeUnit}): \033[0m"
    read -r timeStr
    timeStr=$(echo "${timeStr}" | tr -d ' ')

    timeValue=$(echo "${timeStr}" | awk '{print $1+0}')
    if [[ ! "${timeValue}" =~ ^[0-9]+$ ]]; then
        echo -e "\033[91mInvalid input for reset time:\033[0m ${timeValue}"
        exit 1
    fi

    if [[ "${optionStr}" == "1" ]]; then
        if [[ "${timeValue}" == "1" ]]; then
            cronEntry="0 * * * * /etc/resq.sh"
        elif [[ "${timeValue}" -ge 2 ]]; then
            cronEntry="0 */${timeValue} * * * /etc/resq.sh"
        fi
    elif [[ "${optionStr}" == "2" ]]; then
        cronEntry="*/${timeValue} * * * * /etc/resq.sh"
    fi

    if crontab -l | grep -qF "${cronEntry}"; then
        echo -e "\033[92mOh... Cron entry already exists!\033[0m"
        exit 0
    fi

    (crontab -l ; echo "${cronEntry}") | crontab -

    echo -e "\033[92mCron entry added successfully!\033[0m"
}
function install() {
 # Function to stop the loading animation and exit
    function stop_loading() {
        echo -e "\xE2\x9D\x8C Installation process interrupted."
        exit 1
    }

    # (Ctrl+C)
    trap stop_loading INT
ipv4_forwarding=$(sysctl -n net.ipv4.ip_forward)
    if [[ $ipv4_forwarding -eq 1 ]]; then
        echo "IPv4 forwarding is already enabled."
    else
        sysctl -w net.ipv4.ip_forward=1 &>/dev/null
        echo "IPv4 forwarding has been enabled."
    fi

    ipv6_forwarding=$(sysctl -n net.ipv6.conf.all.forwarding)
    if [[ $ipv6_forwarding -eq 1 ]]; then
        echo "IPv6 forwarding is already enabled."
    else
        # Enable IPv6 forwarding
        sysctl -w net.ipv6.conf.all.forwarding=1 &>/dev/null
        echo "IPv6 forwarding has been enabled."
    fi

    # dns

    # CPU architecture
    arch=$(uname -m)

    # cpu architecture
    case $arch in
        x86_64 | amd64)
            frp_download_url="https://github.com/fatedier/frp/releases/download/v0.52.3/frp_0.52.3_linux_amd64.tar.gz"
            ;;
        aarch64 | arm64)
            frp_download_url="https://github.com/fatedier/frp/releases/download/v0.52.3/frp_0.52.3_linux_arm64.tar.gz"
            ;;
        *)
            display_error "Unsupported CPU architecture: $arch"
            return
            ;;
    esac

    # Download FRP notificatiooooons
    display_notification $'\e[91mDownloading FRP in a sec...\e[0m'
    display_notification $'\e[91mPlease wait, updating...\e[0m'

    # timer
    SECONDS=0

    # Update in the background
    apt update &>/dev/null &
    apt_update_pid=$!

    # Timer
    while [[ -n $(ps -p $apt_update_pid -o pid=) ]]; do
        clear
        display_notification $'\e[93mPlease wait, updating...\e[0m'
        display_notification $'\e[93mAzumi is working in the background, timer: \e[0m'"$SECONDS seconds"
        sleep 1
    done

    # progress bar
    for ((i=0; i<=10; i++)); do
        sleep 0.5
        display_progress 10 $i
    done

    display_checkmark $'\e[92mUpdate completed successfully!\e[0m'

    # Download the appropriate FRP version
    wget "$frp_download_url" -O frp.tar.gz &>/dev/null
    tar -xf frp.tar.gz &>/dev/null

    display_checkmark $'\e[92mFRP installed successfully!\e[0m'

    # sysctl setting
    sysctl -p &>/dev/null

    # notify
    display_notification $'\e[92mIP forward enabled!\e[0m'
    display_loading

    # interrupt
    trap - INT
}

function configure_frp() {
clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mFRP Tunnel Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
  display_notification $'\e[93mStarting FRP Wireguard tunnel...\e[0m'
 printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
echo $'\e[93mSelect server type:\e[0m'
echo $'1. \e[92mKharej\e[0m'
echo $'2. \e[94mIRAN\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mKharej Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
if [[ $server_type == "1" ]]; then
 printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo $'\e[93mSelect Kharej configuration type:\e[0m'
    echo $'1. \e[92mIPv4\e[0m'
    echo $'2. \e[96mIPv6\e[0m'
    printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' kharej_type

    if [[ $kharej_type == "1" ]]; then
        # Kharej IPv4 configuration
	 printf "\e[93m╭───────────────────────────────────────────────╮\e[0m\n"
        read -e -p $'\e[93mEnter \e[92mIran\e[33m IPv4 address: \e[0m' server_addr
        read -e -p $'\e[93mEnter \e[92mtunnel\e[33m port [Same port: 443]: \e[0m' server_port
        read -e -p $'\e[93mEnter \e[92mKharej\e[33m port: \e[0m' local_port
        read -e -p $'\e[93mEnter \e[92mIran\e[33m port: \e[0m' remote_port
	  printf "\e[93m╰───────────────────────────────────────────────╯\e[0m\n"

       

    elif [[ $kharej_type == "2" ]]; then
        # Kharej IPv6 configuration
	 printf "\e[93m╭───────────────────────────────────────────────╮\e[0m\n"
        read -e -p $'\e[33mEnter \e[92mIran\e[33m IPv6 address: \e[0m' server_addr
        read -e -p $'\e[33mEnter \e[92mtunnel\e[33m port [Same port: 443]: \e[0m' server_port
        read -e -p $'\e[33mEnter \e[92mKharej\e[33m port: \e[0m' local_port
        read -e -p $'\e[33mEnter \e[92mIran\e[33m port: \e[0m' remote_port
	printf "\e[93m╰───────────────────────────────────────────────╯\e[0m\n"

      
    else
        echo $'\e[91mInvalid choice. Exiting...\e[0m'
        exit 1
    fi
	

    # frpc.ini 
rm frp_0.52.3_linux_amd64/frpc.ini >/dev/null 2>&1
rm frp_0.52.3_linux_arm64/frpc.ini >/dev/null 2>&1
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    echo "[common]
server_addr = $server_addr
server_port = $server_port
token = azumichwan

[wireguard]
type = udp
local_ip = 127.0.0.1
local_port = $local_port
remote_port = $remote_port
use_encryption = true
use_compression = true" >> frp_0.52.3_linux_$cpu_arch/frpc.ini

    # frpc service
    echo "[Unit]
Description=frpc service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frpc -c /root/frp_0.52.3_linux_$cpu_arch/frpc.ini
Restart=always
RestartSec=10
User=root
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/azumifrpc.service &>/dev/null

    display_checkmark $'\e[92mKharej Wireguard Tunnel has been completed successfully!\e[0m \e[91mYours Truly, Azumi\e[0m'
      # additional commands for Kharej side
    sudo systemctl daemon-reload
    sudo systemctl enable azumifrpc
    sudo systemctl restart azumifrpc
    res_lk
    display_loading
  elif [[ $server_type == "2" ]]; then
  clear
      echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mIran Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
    # Iran configuration
     printf "\e[93m╭───────────────────────────────────────────────╮\e[0m\n"
    read -e -p $'\e[33mEnter \e[92mtunnel\e[33m port [Same port : 443]: \e[0m' bind_port
    read -e -p $'\e[33mEnter \e[92mIran\e[33m port: \e[0m' local_port
    read -e -p $'\e[33mEnter \e[92mKharej\e[33m port: \e[0m' remote_port
   printf "\e[93m╰───────────────────────────────────────────────╯\e[0m\n"
    # frps.ini
rm frp_0.52.3_linux_amd64/frps.ini >/dev/null 2>&1
rm frp_0.52.3_linux_arm64/frps.ini >/dev/null 2>&1
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    echo "[common]
bind_port = $bind_port
token = azumichwan

[wireguard]
type = udp
local_ip = 127.0.0.1
local_port = $local_port
remote_port = $remote_port
use_encryption = true
use_compression = true" >> frp_0.52.3_linux_$cpu_arch/frps.ini

    # frps service
    echo "[Unit]
Description=frps service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frps -c /root/frp_0.52.3_linux_$cpu_arch/frps.ini
Restart=always
RestartSec=10
User=root
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/azumifrps.service &>/dev/null

    display_checkmark $'\e[92mIran Wireguard Tunnel has been completed successfully!\e[0m \e[91mYours Truly, Azumi\e[0m'
     # additional commands for Iran side
    sudo systemctl daemon-reload
    sudo systemctl enable azumifrps
    sudo systemctl restart azumifrps
    res_li
    display_loading
  else
    display_error "Invalid choice. Aborting..."
    return
  fi

  display_checkmark $'\e[92mFRP Wireguard tunnel setup has been completed successfully!\e[0m'
}
function multi_port() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mFRP Multi Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
       printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo "Select an option:"
    echo -e "1. \e[92mKharej Tunnel\e[0m"
    echo -e "2. \e[96mIran Tunnel\e[0m"
    echo -e "3. \e[33mBack to main menu\e[0m"
    printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    read -e -p "Enter your choice Please: " choice

    case $choice in
        1)
            kharej_tunnel_menu
            ;;
        2)
            iran_tunnel_menu
            ;;
        3)
            clear
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
 esac
}
function kharej_tunnel_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mKharej Multi Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
      printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    read -e -p $'\e[93mEnter the \e[92mnumber of Configs\e[93m: \e[0m' num_ipv6
    sleep 1
    echo "Generating Config for you..."

    read -e -p $'\e[93mEnter \e[92mIran\e[93m IPv4|IPv6 address: \e[0m' iran_ipv6
    read -e -p $'\e[93mEnter \e[92mTunnel\e[93m Port:[Example: 443] \e[0m' tunnel_port
   
# frpc.ini 
rm frp_0.52.3_linux_amd64/frpc.ini >/dev/null 2>&1
rm frp_0.52.3_linux_arm64/frpc.ini >/dev/null 2>&1
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frpc.ini <<EOL
[common]
server_addr = $iran_ipv6
server_port = $tunnel_port
authentication_mode = token
token = azumichwan

EOL

    for ((i=1; i<=$num_ipv6; i++)); do

        read -e -p $'\e[93mEnter \e[92mKharej\e[93m port:\e[0m\e[92m[current Config port]\e[0m ' kharej_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m port:\e[0m\e[92m[your new Config port]\e[0m ' iran_port
 printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frpc.ini <<EOL

[wireguard$i]
type = udp
local_port = $kharej_port
remote_port = $iran_port
local_ip = 127.0.0.1
use_encryption = true
use_compression = true

EOL
    done

    display_checkmark $'\e[92mKharej configuration generated. Yours Truly, Azumi.\e[0m'
# Add the service section for Kharej
    cat > /etc/systemd/system/azumifrpc.service <<EOL
[Unit]
Description=frpc service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frpc -c /root/frp_0.52.3_linux_$cpu_arch/frpc.ini
Restart=always
RestartSec=10
User=root
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumifrpc > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumifrpc
    res_lk
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}
function iran_tunnel_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mIran Multi Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
    printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    echo "Generating Iran Config for you..."
    read -e -p $'\e[93mEnter \e[92mTunnel Port\e[93m:[Example: \e[92m443\e[93m] \e[0m' tunnel_port
    
    echo -e "\e[93mGenerating config for you...\e[0m"
    #frps.ini
rm frp_0.52.3_linux_amd64/frps.ini >/dev/null 2>&1
rm frp_0.52.3_linux_arm64/frps.ini >/dev/null 2>&1
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frps.ini <<EOL
[common]
bind_port = $tunnel_port
token = azumichwan

EOL
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m port Range:\e[0m\e[92m[example : 50820,50821,50822]\e[0m ' kharej_wireguard_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m port Range:\e[0m\e[92m[example : 50823,50824,50825]\e[0m ' iran_wireguard_port
  printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frps.ini <<EOL
[wireguard$i]
type = udp
local_ip = 127.0.0.1
local_port = $iran_wireguard_port
remote_port = $kharej_wireguard_port
use_encryption = true
use_compression = true

EOL

    display_checkmark $'\e[92mIran configuration generated. Yours Truly, Azumi.\e[0m'
# Add the service section for Kharej
    cat > /etc/systemd/system/azumifrps.service <<EOL
[Unit]
Description=frps service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frps -c /root/frp_0.52.3_linux_$cpu_arch/frps.ini
Restart=always
RestartSec=10
User=root
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumifrps > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumifrps
    res_li
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}
# uninstal function
function uni() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mUninstallation Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
       printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo "Select an option:"
    echo -e "1. \e[92mSimple UDP\e[0m"
    echo -e "2. \e[93mKCP + UDP\e[0m"
	echo -e "3. \e[96mQuic + UDP\e[0m"
    echo -e "4. \e[33mBack to main menu\e[0m"
    printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    read -e -p "Enter your choice Please: " choice

    case $choice in
        1)
            u_menu
            ;;
        2)
            k_menu
            ;;
		3)
            q_menu
            ;;
        4)
            clear
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
 esac
}
q_menu() {
  deleteCron5
  deleteCron6
  display_notification $'\e[93mStarting uninstallation of FRP service...\e[0m'
  sleep 1
  sudo rm -rf frp_0.52.3_linux_amd64 &>/dev/null
  sudo rm -rf frp_0.52.3_linux_arm64 &>/dev/null

  sudo systemctl stop azumiquicc.service &>/dev/null
  sudo systemctl disable azumiquicc.service &>/dev/null
  sudo rm /etc/systemd/system/azumiquicc.service &>/dev/null

  sudo systemctl stop azumiquics.service &>/dev/null
  sudo systemctl disable azumiquics.service &>/dev/null
  sudo rm /etc/systemd/system/azumiquics.service &>/dev/null

  display_notification $'\e[93mUninstalling FRP service (◡﹏◡✿)...\e[0m'

  # Kawaii azumi
  local total=10
  for ((i = 0; i <= total; i++)); do
    sleep 0.5
    display_progress "$total" "$i" $'\e[93mUninstalling FRP service... Please wait...\e[0m'
  done

   # Complete msg
  display_checkmark $'\e[92mFRP service has been uninstalled successfully!\e[0m'
}
k_menu() {
  deleteCron3
  deleteCron4
  display_notification $'\e[93mStarting uninstallation of FRP service...\e[0m'
  sleep 1
  sudo rm -rf frp_0.52.3_linux_amd64 &>/dev/null
  sudo rm -rf frp_0.52.3_linux_arm64 &>/dev/null

 
  sudo systemctl stop azumikcpc.service &>/dev/null
  sudo systemctl disable azumikcpc.service &>/dev/null
  sudo rm /etc/systemd/system/azumikcpc.service &>/dev/null
  
  sudo systemctl stop azumikcps.service &>/dev/null
  sudo systemctl disable azumikcps.service &>/dev/null
  sudo rm /etc/systemd/system/azumikcps.service &>/dev/null

  display_notification $'\e[93mUninstalling FRP service (◡﹏◡✿)...\e[0m'

  # Kawaii azumi
  local total=10
  for ((i = 0; i <= total; i++)); do
    sleep 0.5
    display_progress "$total" "$i" $'\e[93mUninstalling FRP service... Please wait...\e[0m'
  done

   # Complete msg
  display_checkmark $'\e[92mFRP service has been uninstalled successfully!\e[0m'
}
u_menu() {
  deleteCron1
  deleteCron2
  display_notification $'\e[93mStarting uninstallation of FRP service...\e[0m'
  sleep 1
  sudo rm -rf frp_0.52.3_linux_amd64 &>/dev/null
  sudo rm -rf frp_0.52.3_linux_arm64 &>/dev/null

  sudo systemctl stop azumifrpc.service &>/dev/null
  sudo systemctl disable azumifrpc.service &>/dev/null
  sudo rm /etc/systemd/system/azumifrpc.service &>/dev/null
  
  sudo systemctl stop azumifrps.service &>/dev/null
  sudo systemctl disable azumifrps.service &>/dev/null
  sudo rm /etc/systemd/system/azumifrps.service &>/dev/null


  display_notification $'\e[93mUninstalling FRP service (◡﹏◡✿)...\e[0m'

  # Kawaii azumi
  local total=10
  for ((i = 0; i <= total; i++)); do
    sleep 0.5
    display_progress "$total" "$i" $'\e[93mUninstalling FRP service... Please wait...\e[0m'
  done

   # Complete msg
  display_checkmark $'\e[92mFRP service has been uninstalled successfully!\e[0m'
}
status_menu() {
    clear
    echo -e '\033[92m ^ ^\033[0m'
    echo -e '\033[92m(\033[91mO,O\033[92m)\033[0m'
    echo -e '\033[92m(   ) \033[93mStatus Menu\033[0m'
    echo -e '\033[92m "-"\033[93m══════════════════════════\033[0m'
    echo -e "\033[93m╭───────────────────────────────────────╮\033[0m"
    echo -e '\033[93mChoose what to do:\033[0m'
    echo -e '1. \033[92mSimple UDP  \033[0m'
    echo -e '2. \033[93mUDP + KCP\033[0m'
    echo -e '3. \033[96mUDP + Quic \033[0m'
    echo -e '0. \033[94mBack to the main menu\033[0m'
    echo -e "\033[93m╰───────────────────────────────────────╯\033[0m"

    while true; do
        read -p $'\033[38;5;205mEnter your choice Please: \033[0m' server_type
        case "$server_type" in
            1)
                status1_menu
                break
                ;;
            2)
                statuskcp_menu
                break
                ;;
            3)
                statusquic_menu
                break
                ;;
            0)
                clear
                main_menu
                break
                ;;
            *)
                echo 'Invalid choice.'
                ;;
        esac
    done
}

statusquic_menu() {
    clear
    echo -e '\033[92m ^ ^\033[0m'
    echo -e '\033[92m(\033[91mO,O\033[92m)\033[0m'
    echo -e '\033[92m(   ) \033[93mStatus Menu\033[0m'
    echo -e '\033[92m "-"\033[93m══════════════════════════\033[0m'

    declare -A services=(
        ['iran']='azumiquics'
        ['kharej']='azumiquicc'
    )

    echo -e "\033[93m╔════════════════════════════════════════════╗\033[0m"
    echo -e "\033[93m║                 \033[92mFRP Status\033[93m                 ║\033[0m"
    echo -e "\033[93m╠════════════════════════════════════════════╣\033[0m"

    for service in "${!services[@]}"; do
        service_names=(${services[$service]})
        for service_name in "${service_names[@]}"; do
            config_service_name="${service_name}.service"
            status_output=$(systemctl is-active "$config_service_name" 2>/dev/null | tr -d '\n')

            if [[ $status_output == "active" ]]; then
                status="\033[92m✓ Active     \033[0m"
                if [[ $service == 'iran' ]]; then
                    display_name='\033[93mIRAN Server   \033[0m'
                elif [[ $service == 'kharej' ]]; then
                    display_name='\033[93mKharej Service\033[0m'
                else
                    display_name="$service"
                fi
                echo -e "\033[93m║\033[0m    ${display_name}:   |    ${status}    \033[93m║\033[0m"
            fi
        done
    done

    echo -e "\033[93m╚════════════════════════════════════════════╝\033[0m"
}

statuskcp_menu() {
    clear
    echo -e '\033[92m ^ ^\033[0m'
    echo -e '\033[92m(\033[91mO,O\033[92m)\033[0m'
    echo -e '\033[92m(   ) \033[93mStatus Menu\033[0m'
    echo -e '\033[92m "-"\033[93m══════════════════════════\033[0m'

    declare -A services=(
        ['iran']='azumikcps'
        ['kharej']='azumikcpc'
    )

    echo -e "\033[93m╔════════════════════════════════════════════╗\033[0m"
    echo -e "\033[93m║                 \033[92mFRP Status\033[93m                 ║\033[0m"
    echo -e "\033[93m╠════════════════════════════════════════════╣\033[0m"

    for service in "${!services[@]}"; do
        service_names=(${services[$service]})
        for service_name in "${service_names[@]}"; do
            config_service_name="${service_name}.service"
            status_output=$(systemctl is-active "$config_service_name" 2>/dev/null | tr -d '\n')

            if [[ $status_output == "active" ]]; then
                status="\033[92m✓ Active     \033[0m"
                if [[ $service == 'iran' ]]; then
                    display_name='\033[93mIRAN Server   \033[0m'
                elif [[ $service == 'kharej' ]]; then
                    display_name='\033[93mKharej Service\033[0m'
                else
                    display_name="$service"
                fi
                echo -e "\033[93m║\033[0m    ${display_name}:   |    ${status}    \033[93m║\033[0m"
            fi
        done
    done

    echo -e "\033[93m╚════════════════════════════════════════════╝\033[0m"
}
status1_menu() {
    clear
    echo -e '\033[92m ^ ^\033[0m'
    echo -e '\033[92m(\033[91mO,O\033[92m)\033[0m'
    echo -e '\033[92m(   ) \033[93mStatus Menu\033[0m'
    echo -e '\033[92m "-"\033[93m══════════════════════════\033[0m'

    declare -A services=(
        ['iran']='azumifrps'
        ['kharej']='azumifrpc'
    )

    echo -e "\033[93m╔════════════════════════════════════════════╗\033[0m"
    echo -e "\033[93m║                 \033[92mFRP Status\033[93m                 ║\033[0m"
    echo -e "\033[93m╠════════════════════════════════════════════╣\033[0m"

    for service in "${!services[@]}"; do
        service_names=(${services[$service]})
        for service_name in "${service_names[@]}"; do
            config_service_name="${service_name}.service"
            status_output=$(systemctl is-active "$config_service_name" 2>/dev/null | tr -d '\n')

            if [[ $status_output == "active" ]]; then
                status="\033[92m✓ Active     \033[0m"
                if [[ $service == 'iran' ]]; then
                    display_name='\033[93mIRAN Server   \033[0m'
                elif [[ $service == 'kharej' ]]; then
                    display_name='\033[93mKharej Service\033[0m'
                else
                    display_name="$service"
                fi
                echo -e "\033[93m║\033[0m    ${display_name}:   |    ${status}    \033[93m║\033[0m"
            fi
        done
    done

    echo -e "\033[93m╚════════════════════════════════════════════╝\033[0m"
}
function check_service_status() {
  local service_name=$1
  local status=$(systemctl show "$service_name" --property=ActiveState --no-pager --plain)
  if [[ $status == "ActiveState=active" ]]; then
    if [[ $service_name == "azumikcpc" || $service_name == "azumiquicc" || $service_name == "azumifrpc" ]]; then
      echo -e "\e[92m                \xE2\x9C\x94 Kharej service is running\e[0m"
      return 0
    elif [[ $service_name == "azumikcps" || $service_name == "azumiquics" || $service_name == "azumifrps" ]]; then
      echo -e "\e[92m                \xE2\x9C\x94 Iran service is running\e[0m"
      return 0
    fi
  fi
  return 1
}

function display_service_status() {
  # box
  printf "\e[93m          ╭───────────────────────────────────────╮\e[0m\n"
  printf "\e[93m          │             Service Status            │\e[0m\n"
  printf "\e[93m          ├───────────────────────────────────────┤\e[0m\n"

  # Check FRP Kharej services
  local active_service_found=0
  check_service_status "azumikcpc" && active_service_found=1
  check_service_status "azumiquicc" && active_service_found=1
  check_service_status "azumifrpc" && active_service_found=1

  # Check FRP Iran services
  check_service_status "azumikcps" && active_service_found=1
  check_service_status "azumiquics" && active_service_found=1
  check_service_status "azumifrps" && active_service_found=1

  if [[ $active_service_found -eq 0 ]]; then
    echo -e "\e[91m                   \xE2\x9C\x98 No Service is running\e[0m"
  fi

  printf "\e[93m          │                                       │\e[0m\n"
  printf "\e[93m          ╰───────────────────────────────────────╯\e[0m\n"
}

function Kcp_port() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mFRP KCP Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
       printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo "Select an option:"
    echo -e "1. \e[92mKharej Tunnel\e[0m"
    echo -e "2. \e[96mIran Tunnel\e[0m"
    echo -e "3. \e[33mBack to main menu\e[0m"
    printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    read -e -p "Enter your choice Please: " choice

    case $choice in
        1)
            kharej_kcp_menu
            ;;
        2)
            iran_kcp_menu
            ;;
        3)
            clear
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
 esac
}
function kharej_kcp_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mKharej KCP Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
      printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    read -e -p $'\e[93mEnter the \e[92mNumber of Configs\e[93m: \e[0m' num_configs
    sleep 1
    echo "Generating Config for you..."

    read -e -p $'\e[93mEnter \e[92mIran\e[93m IPV4|IPV6 address: \e[0m' iran_ipv6
    read -e -p $'\e[93mEnter \e[92mKCP\e[93m Port:[Example: 443] \e[0m' tunnel_port
   
# frpc.ini 
rm frp_0.52.3_linux_amd64/frpck.toml >/dev/null 2>&1
rm frp_0.52.3_linux_arm64/frpck.toml >/dev/null 2>&1
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frpck.toml <<EOL
[common]
server_addr = $iran_ipv6
server_port = $tunnel_port
transport.protocol = kcp
authentication_mode = token
token = azumichwan

EOL

    for ((i = 1; i <= $num_configs; i++)); do
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m port:\e[0m\e[92m[current Config port]\e[0m ' kharej_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m port:\e[0m\e[92m[your new Config port]\e[0m ' iran_port
 printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frpck.toml <<EOL

[wireguard$i]
type = udp
local_port = $kharej_port
remote_port = $iran_port
local_ip = 127.0.0.1
use_encryption = true
use_compression = true

EOL
    done

    display_checkmark $'\e[92mKharej configuration generated. Yours Truly, Azumi.\e[0m'
# Add the service section for Kharej
    cat > /etc/systemd/system/azumikcpc.service <<EOL
[Unit]
Description=frpc service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frpc -c /root/frp_0.52.3_linux_$cpu_arch/frpck.toml
Restart=always
RestartSec=10
User=root
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumikcpc > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumikcpc
    res_kcpk
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}
function iran_kcp_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mIran KCP Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
    printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    echo "Generating Iran Config for you..."
    read -e -p $'\e[93mEnter \e[92mKCP Port\e[93m:[Example: \e[92m443\e[93m] \e[0m' tunnel_port
    
    echo -e "\e[93mGenerating config for you...\e[0m"
    #frps.ini
rm frp_0.52.3_linux_amd64/frpsk.toml >/dev/null 2>&1
rm frp_0.52.3_linux_arm64/frpsk.toml >/dev/null 2>&1
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frpsk.toml <<EOL
[common]
bind_port = $tunnel_port
kcpBindPort = $tunnel_port
token = azumichwan

EOL
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m port Range:\e[0m\e[92m[example : 50820,50821]\e[0m ' kharej_wireguard_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m port Range:\e[0m\e[92m[example : 50823,50824]\e[0m ' iran_wireguard_port
  printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frpsk.toml <<EOL
[wireguard$i]
type = udp
local_ip = 127.0.0.1
local_port = $iran_wireguard_port
remote_port = $kharej_wireguard_port
use_encryption = true
use_compression = true

EOL

    display_checkmark $'\e[92mIran configuration generated. Yours Truly, Azumi.\e[0m'
# Add the service section for Kharej
    cat > /etc/systemd/system/azumikcps.service <<EOL
[Unit]
Description=frps service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frps -c /root/frp_0.52.3_linux_$cpu_arch/frpsk.toml
Restart=always
RestartSec=10
User=root
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumikcps > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumikcps
    res_kcpi
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}

function quic_port() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mFRP Quic Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
       printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo "Select an option:"
    echo -e "1. \e[92mKharej Tunnel\e[0m"
    echo -e "2. \e[96mIran Tunnel\e[0m"
    echo -e "3. \e[33mBack to main menu\e[0m"
    printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    read -e -p "Enter your choice Please: " choice

    case $choice in
        1)
            kharej_quic_menu
            ;;
        2)
            iran_quic_menu
            ;;
        3)
            clear
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
 esac
}
function kharej_quic_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mKharej Quic Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
      printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    read -e -p $'\e[93mEnter the \e[92mNumber of Configs\e[93m: \e[0m' num_configs
    sleep 1
    echo "Generating Config for you..."

    read -e -p $'\e[93mEnter \e[92mIran\e[93m IPV4|IPV6 address: \e[0m' iran_ipv6
    read -e -p $'\e[93mEnter \e[92mQuic\e[93m Port: \e[0m' tunnel_port
   
# frpc.ini 
rm frp_0.52.3_linux_amd64/frpcq.toml >/dev/null 2>&1
rm frp_0.52.3_linux_arm64/frpcq.toml >/dev/null 2>&1
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frpcq.toml <<EOL
[common]
server_addr = $iran_ipv6
server_port = $tunnel_port
transport.protocol = quic
authentication_mode = token
token = azumichwan

EOL

    for ((i = 1; i <= $num_configs; i++)); do
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m port:\e[0m\e[92m[current Config port]\e[0m ' kharej_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m port:\e[0m\e[92m[your new Config port]\e[0m ' iran_port
 printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frpcq.toml <<EOL

[wireguard$i]
type = udp
local_port = $kharej_port
remote_port = $iran_port
local_ip = 127.0.0.1
use_encryption = true
use_compression = true

EOL
    done

    display_checkmark $'\e[92mKharej configuration generated. Yours Truly, Azumi.\e[0m'
# Add the service section for Kharej
    cat > /etc/systemd/system/azumiquicc.service <<EOL
[Unit]
Description=frpc service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frpc -c /root/frp_0.52.3_linux_$cpu_arch/frpcq.toml
Restart=always
RestartSec=10
User=root
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumiquicc > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumiquicc
    res_quick
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}
function iran_quic_menu() {
  clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mIran Quic Menu\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
    printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    echo "Generating Iran Config for you..."
    read -e -p $'\e[93mEnter \e[92mQuic Port\e[93m: \e[0m' tunnel_port
    
    echo -e "\e[93mGenerating config for you...\e[0m"
    #frps.ini
rm frp_0.52.3_linux_amd64/frpsq.toml >/dev/null 2>&1
rm frp_0.52.3_linux_arm64/frpsq.toml >/dev/null 2>&1
# CPU architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
  cpu_arch="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  cpu_arch="arm64"
else
  echo -e "\e[93mUnsupported CPU architecture.\e[0m"
  exit 1
fi
    cat > frp_0.52.3_linux_$cpu_arch/frpsq.toml <<EOL
[common]
bind_port = $tunnel_port
quicBindPort = $tunnel_port
token = azumichwan

EOL
        read -e -p $'\e[93mEnter \e[92mKharej\e[93m port Range:\e[0m\e[92m[example : 50820,50821]\e[0m ' kharej_wireguard_port
        read -e -p $'\e[93mEnter \e[92mIran\e[93m port Range:\e[0m\e[92m[example : 50823,50824]\e[0m ' iran_wireguard_port
  printf "\e[93m──────────────────────────────────────────────────\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frpsq.toml <<EOL
[wireguard$i]
type = udp
local_ip = 127.0.0.1
local_port = $iran_wireguard_port
remote_port = $kharej_wireguard_port
use_encryption = true
use_compression = true

EOL

    display_checkmark $'\e[92mIran configuration generated. Yours Truly, Azumi.\e[0m'
# Add the service section for Kharej
    cat > /etc/systemd/system/azumiquics.service <<EOL
[Unit]
Description=frps service
After=network.target

[Service]
ExecStart=/root/frp_0.52.3_linux_$cpu_arch/./frps -c /root/frp_0.52.3_linux_$cpu_arch/frpsq.toml
Restart=always
RestartSec=10
User=root
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOL
echo "Reloading daemon..." > /dev/null 2>&1
    systemctl daemon-reload > /dev/null 2>&1

    echo "Enabling FRP service..." > /dev/null 2>&1
    systemctl enable azumiquics > /dev/null 2>&1

    echo "Starting FRP  service..."
    systemctl restart azumiquics
    res_quici
    display_checkmark $'\e[92mFRP Service started.\e[0m'
}
function main_menu() {
  # Print the logo
  display_logo
  echo ""
  echo -e "\e[93m\033[1m       Join OPIRAN Telegram: \e[34m@https://t.me/OPIranClub\e[0m\e[0m"
  printf "\e[93m        +ꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥ+\e[0m\n" 
  echo -e "\e[93m╔════════════════════════════════════════════════════════════════╗\e[0m"  
  echo -e "\e[93m║           ▌║█║▌│║▌│║▌║▌█║ \e[92mMain Menu\e[93m  ▌│║▌║▌│║║▌█║▌             ║\e[0m"   
  echo -e "\e[93m╠════════════════════════════════════════════════════════════════╣\e[0m" 
  echo -e "\e[37m0. \e[91mStatus"
  echo -e "\e[37m1. \e[96mInstall FRP"
  echo -e "\e[37m2. \e[93mEdit Reset Timer"
  echo -e "\e[37m3. \e[32mFRP Simple UDP tunnel setup"
  echo -e "\e[37m4. \e[93mFRP UDP + KCP tunnel setup"
  echo -e "\e[37m5. \e[92mFRP UDP + Quic tunnel setup"
  echo -e "\e[37m6. \e[96mFRP Multi UDP tunnel setup"
  echo -e "\e[37m7.\e[91m Uninstall FRP Service\e[0m"
  echo -e "\e[37m8. \e[92mRestart Service\e[0m"
  echo -e "\e[37m9. \e[91;1mExit\e[0m"

  read -e -p $'\e[5mEnter your choice Please: \e[0m' choice 

  case $choice in
    0)
      status_menu
      ;;
    1)
      install
      ;;
    2)
      timez
      ;;
    3)
      configure_frp
      ;;
    4)
      Kcp_port
      ;;
    5)
      quic_port
      ;;
    6)
      multi_port
      ;;
    7)
      uni
      ;;
    8)
      restart_service
      ;;
    9)
      exit 0
      ;;
    *)
      display_error "Invalid choice. Please try again."
      main_menu
      ;;
  esac

  read -p "Press Enter to continue..."
  main_menu
}

function restart_service() {
  clear
  display_notification $'\e[93mRestarting FRP service...\e[0m'
    # Check 1
    systemctl daemon-reload
    systemctl restart azumifrpc.service > /dev/null 2>&1
	systemctl restart azumikcpc.service > /dev/null 2>&1
	systemctl restart azumiquicc.service > /dev/null 2>&1

    # Check 2
    systemctl restart azumifrps.service > /dev/null 2>&1
	systemctl restart azumikcps.service > /dev/null 2>&1
	systemctl restart azumiquics.service > /dev/null 2>&1
    display_checkmark $'\e[92mFRP Service restarted.\e[0m'

  
  display_checkmark $'\e[92mFRP service restarted successfully!\e[0m'
  sleep 2
  clear
}

main_menu
