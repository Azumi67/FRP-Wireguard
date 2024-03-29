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


function res_li() {
    if test -f /etc/res.sh; then
        rm /etc/res.sh
    fi

    cat <<EOF > /etc/res.sh
#!/bin/bash
kill -9 \$(pgrep frps)
systemctl daemon-reload
systemctl restart azumifrps
EOF

    chmod +x /etc/res.sh

    existing_entry="0 */2 * * * /etc/res.sh"
    existing_crontab=""

    existing_crontab=$(crontab -l 2>/dev/null)

    if [[ $existing_entry == *"$existing_crontab"* ]]; then
        echo -e "\033[91mCrontab already exists.\033[0m"
    else
        new_crontab=$(echo -e "$existing_crontab\n0 */6 * * * /etc/res.sh\n")
        echo "$new_crontab" | crontab -
        echo -e "\033[92m6 hours reset timer added!\033[0m"
    fi

    echo -e "\033[92mIT IS DONE.!\033[0m"
}

function res_lk() {
    if test -f /etc/res.sh; then
        rm /etc/res.sh
    fi

    cat <<EOF > /etc/res.sh
#!/bin/bash
kill -9 \$(pgrep frpc)
systemctl daemon-reload
systemctl restart azumifrpc
EOF

    chmod +x /etc/res.sh

    existing_entry="0 */2 * * * /etc/res.sh"
    existing_crontab=""

    existing_crontab=$(crontab -l 2>/dev/null)

    if [[ $existing_entry == *"$existing_crontab"* ]]; then
        echo -e "\033[91mCrontab already exists.\033[0m"
    else
        new_crontab=$(echo -e "$existing_crontab\n0 */6 * * * /etc/res.sh\n")
        echo "$new_crontab" | crontab -
        echo -e "\033[92m6 hours reset timer added!\033[0m"
    fi

    echo -e "\033[92mIT IS DONE.!\033[0m"
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
read -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
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
    read -p $'\e[38;5;205mEnter your choice Please: \e[0m' kharej_type

    if [[ $kharej_type == "1" ]]; then
        # Kharej IPv4 configuration
	 printf "\e[93m╭───────────────────────────────────────────────╮\e[0m\n"
        read -p $'\e[93mEnter \e[92mIran\e[33m IPv4 address: \e[0m' server_addr
        read -p $'\e[93mEnter \e[92mtunnel\e[33m port [Same port: 443]: \e[0m' server_port
        read -p $'\e[93mEnter \e[92mKharej\e[33m Wireguard port: \e[0m' local_port
        read -p $'\e[93mEnter \e[92mIran\e[33m Wireguard port: \e[0m' remote_port
	  printf "\e[93m╰───────────────────────────────────────────────╯\e[0m\n"

       

    elif [[ $kharej_type == "2" ]]; then
        # Kharej IPv6 configuration
	 printf "\e[93m╭───────────────────────────────────────────────╮\e[0m\n"
        read -p $'\e[33mEnter \e[92mIran\e[33m IPv6 address: \e[0m' server_addr
        read -p $'\e[33mEnter \e[92mtunnel\e[33m port [Same port: 443]: \e[0m' server_port
        read -p $'\e[33mEnter \e[92mKharej\e[33m Wireguard port: \e[0m' local_port
        read -p $'\e[33mEnter \e[92mIran\e[33m Wireguard port: \e[0m' remote_port
	printf "\e[93m╰───────────────────────────────────────────────╯\e[0m\n"

      
    else
        echo $'\e[91mInvalid choice. Exiting...\e[0m'
        exit 1
    fi

    # frpc.ini 
rm frp_0.52.3_linux_amd64/frpc.ini
rm frp_0.52.3_linux_arm64/frpc.ini
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
    read -p $'\e[33mEnter \e[92mtunnel\e[33m port [Same port : 443]: \e[0m' bind_port
    read -p $'\e[33mEnter \e[92mIran\e[33m Wireguard port: \e[0m' local_port
    read -p $'\e[33mEnter \e[92mKharej\e[33m Wireguard port: \e[0m' remote_port
   printf "\e[93m╰───────────────────────────────────────────────╯\e[0m\n"
    # frps.ini
    rm frp_0.52.3_linux_amd64/frps.ini
rm frp_0.52.3_linux_arm64/frps.ini
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
    read -p "Enter your choice Please: " choice

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
      printf "\e[93m╭────────────────────────────────────────────────────╮\e[0m\n"
    read -p $'\e[93mNumber of Kharej IPv6 addresses needed: \e[0m' num_ipv6
    sleep 1
    echo "Generating Config for you..."

    read -p $'\e[93mEnter \e[92mIran\e[93m IPv6 address: \e[0m' iran_ipv6
    read -p $'\e[93mEnter \e[92mTunnel\e[93m Port:[Example: 443] \e[0m' tunnel_port
   
# frpc.ini 
rm frp_0.52.3_linux_amd64/frpc.ini
rm frp_0.52.3_linux_arm64/frpc.ini 
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
        read -p $'\e[93mEnter your \e[92mKharej '$i$'th \e[93mIPv6 address:\e[0m\e[92m[Enter your Kharej IPV6s]\e[0m ' kharej_ipv6
        read -p $'\e[93mEnter \e[92mKharej\e[93m Wireguard port:\e[0m\e[92m[This is your current Wireguard port]\e[0m ' kharej_port
        read -p $'\e[93mEnter \e[92mIran\e[93m Wireguard port:\e[0m\e[92m[This will be your new Wireguard port]\e[0m ' iran_port
 printf "\e[93m╰────────────────────────────────────────────────────────────────────────────────────────╯\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frpc.ini <<EOL

[wireguard$i]
type = udp
local_port = $kharej_port
remote_port = $iran_port
local_ip$i = $kharej_ipv6
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
    printf "\e[93m╭────────────────────────────────────────────────────╮\e[0m\n"
    echo "Generating Iran Config for you..."
    read -p $'\e[93mEnter \e[92mTunnel Port\e[93m:[Example: \e[92m443\e[93m] \e[0m' tunnel_port
    
    echo -e "\e[93mGenerating config for you...\e[0m"
    #frps.ini
    rm frp_0.52.3_linux_amd64/frps.ini
rm frp_0.52.3_linux_arm64/frps.ini
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
        read -p $'\e[93mEnter \e[92mKharej\e[93m Wireguard port Range:\e[0m\e[92m[example : 50820,50821,50822]\e[0m ' kharej_wireguard_port
        read -p $'\e[93mEnter \e[92mIran\e[93m Wireguard port Range:\e[0m\e[92m[example : 50823,50824,50825]\e[0m ' iran_wireguard_port
  printf "\e[93m╰────────────────────────────────────────────────────────────────────────────────────────╯\e[0m\n"
    
        cat >> frp_0.52.3_linux_$cpu_arch/frps.ini <<EOL
[wireguard$i]
type = tcp
local_ip$i = 127.0.0.1
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
function uninstall() {
  rmve_cron
  display_notification $'\e[93mStarting uninstallation of FRP service...\e[0m'
  sleep 1

  # Deactivate service frp kharej
  sudo systemctl stop azumifrpc.service &>/dev/null
  sudo systemctl disable azumifrpc.service &>/dev/null
  sudo rm /etc/systemd/system/azumifrpc.service &>/dev/null

  # Deactivate service frp iran
  sudo systemctl stop azumifrps.service &>/dev/null
  sudo systemctl disable azumifrps.service &>/dev/null
  sudo rm /etc/systemd/system/azumifrps.service &>/dev/null

  # Start the uninstallation process
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

# status
function display_service_status() {
  sudo systemctl is-active azumifrpc.service &>/dev/null
  local frpc_status=$?
  if [[ $frpc_status -eq 0 ]]; then
    frpc_status_msg="\e[92m\xE2\x9C\x94 FRP Kharej service is running\e[0m" 
  else
    frpc_status_msg="\e[91m\xE2\x9C\x98 FRP Kharej service is not running\e[0m" 
  fi

  sudo systemctl is-active azumifrps.service &>/dev/null
  local frps_status=$?
  if [[ $frps_status -eq 0 ]]; then
    frps_status_msg="\e[92m\xE2\x9C\x94 FRP Iran service is running\e[0m" 
  else
    frps_status_msg="\e[91m\xE2\x9C\x98 FRP Iran service is not running\e[0m" 
  fi

  # box
  printf "\e[93m+-------------------------------------+\e[0m\n"  
  printf "\e[93m| %-35b |\e[0m\n" "$frpc_status_msg"  
  printf "\e[93m| %-35b |\e[0m\n" "$frps_status_msg"  
  printf "\e[93m+-------------------------------------+\e[0m\n"  
}


# menu asli
function main_menu() {
# Print the logo
  display_logo
  echo ""
  echo -e "\e[93m\033[1mJoin OPIRAN Telegram: \e[34m@https://t.me/OPIranClub\e[0m\e[0m"
  printf "\e[93m+ꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥꕥ+\e[0m\n" 
  echo -e "\e[93m╔════════════════════════════════════════════════════════════════╗\e[0m"  
  echo -e "\e[93m║           ▌║█║▌│║▌│║▌║▌█║ \e[92mMain Menu\e[93m  ▌│║▌║▌│║║▌█║▌             ║\e[0m"   
  echo -e "\e[93m╠════════════════════════════════════════════════════════════════╣\e[0m" 
  display_service_status
  echo -e "\e[37m1. \e[96mInstall FRP"
  echo -e "\e[37m2. \e[32mFRP Wireguard tunnel setup"
  echo -e "\e[37m3. \e[35mFRP Multi Wireguard tunnel setup"
  echo -e "\e[37m4.\e[1m \e[38;5;33mUninstall FRP Service\e[0m"
  echo -e "\e[37m5. \e[33;1mRestart Service\e[0m"
  echo -e "\e[37m0. \e[91;1mExit\e[0m"

 read -e -p $'\e[5mEnter your choice Please: \e[0m' choice 

  case $choice in
    1)
      install
      ;;
    2)
      configure_frp
      ;;
	3)
      multi_port
      ;;	  
    4)
      uninstall
      ;;
    5)
      restart_service
      ;;
    0)
      exit 0
      ;;
    *)
      display_error "Invalid choice. Please try again."
      main_menu
      ;;
  esac

  main_menu
}

function restart_service() {
  clear
  display_notification $'\e[93mRestarting FRP service...\e[0m'
    # Check 1
    systemctl daemon-reload
    systemctl restart azumifrpc.service > /dev/null 2>&1

    # Check 2
    systemctl restart azumifrps.service > /dev/null 2>&1
    display_checkmark $'\e[92mFRP Service restarted.\e[0m'

  
  display_checkmark $'\e[92mFRP service restarted successfully!\e[0m'
  sleep 2
  clear
}

main_menu
