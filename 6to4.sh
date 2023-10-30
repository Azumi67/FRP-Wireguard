#!/bin/bash
#
# Private IP Tunnel Configuration Script
# Author: github.com/Azumi67
#
# This script is designed to simplify the installation and configuration of private ips.
# Tested on Ubuntu 20 - Debian 12
#
# Usage:
#   - Run the script with root privileges.
#   - Follow the on-screen prompts to install, configure, or uninstall the tunnel.
#
#
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
#logo2
function display_logoo() {
    echo -e "\e[92m$logoo\e[0m"
}
#art2
logoo=$(cat << "EOF"

  _____       _     _      
 / ____|     (_)   | |     
| |  __ _   _ _  __| | ___ 
| | |_ | | | | |/ _` |/ _ \
| |__| | |_| | | (_| |  __/
 \_____|\__,_|_|\__,_|\___|
EOF
)
#logo
function display_logo() {
echo -e "\033[1;96m$logo\033[0m"
}
# art
logo=$(cat << "EOF"
⠀⠀               ⠄⠠⠤⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⠀⠀⢀⠠⢀⣢⣈⣉⠁⡆⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⡏⢠⣾⢷⢶⣄⣕⠢⢄⠀⠀⣀⣠⠤⠔⠒⠒⠒⠒⠒⠒⠢⠤⠄⣀⠤⢊⣤⣶⣿⡿⣿⢹⢀⡇⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⢻⠈⣿⢫⡞⠛⡟⣷⣦⡝⠋⠉⣤⣤⣶⣶⣶⣿⣿⣿⡗⢲⣴⠀⠈⠑⣿⡟⡏⠀⢱⣮⡏⢨⠃⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⠸⡅⣹⣿⠀⠀⢩⡽⠋⣠⣤⣿⣿⣏⣛⡻⠿⣿⢟⣹⣴⢿⣹⣿⡟⢦⣀⠙⢷⣤⣼⣾⢁⡾⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀             ⠀⢻⡀⢳⣟⣶⠯⢀⡾⢍⠻⣿⣿⣽⣿⣽⡻⣧⣟⢾⣹⡯⢷⡿⠁⠀⢻⣦⡈⢿⡟⠁⡼⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀             ⠀⢷⠠⢻⠏⢰⣯⡞⡌⣵⠣⠘⡉⢈⠓⡿⠳⣯⠋⠁⠀⠀⢳⡀⣰⣿⣿⣷⡈⢣⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀             ⠀⠀⠙⣎⠀⣿⣿⣷⣾⣷⣼⣵⣆⠂⡐⢀⣴⣌⠀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣷⣀⠣⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀            ⠀⠀  ⠄⠑⢺⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣳⣿⢽⣧⡤⢤⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀            ⠀⠀  ⢸⣈⢹⣟⣿⣿⣿⣿⣿⣻⢹⣿⣻⢿⣿⢿⣽⣳⣯⣿⢷⣿⡷⣟⣯⣻⣽⠧⠾⢤⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀             ⠀ ⢇⠤⢾⣟⡾⣽⣿⣽⣻⡗⢹⡿⢿⣻⠸⢿⢯⡟⡿⡽⣻⣯⣿⣎⢷⣣⡿⢾⢕⣎⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀             ⠀⡠⡞⡟⣻⣮⣍⡛⢿⣽⣻⡀⠁⣟⣣⠿⡠⣿⢏⡞⠧⠽⢵⣳⣿⣺⣿⢿⡋⠙⡀⠇⠱⠀⠀⠀
⠀⠀⠀             ⠀⢰⠠⠁⠀⢻⡿⣛⣽⣿⢟⡁\033[1;91m⣭⣥⣅⠀⠀⠀⠀⠀⠀⣶⣟⣧\033[1;96m⠿⢿⣿⣯⣿⡇⠀⡇⠀⢀⡇⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⠀⢸⠀⠀⡇⢹⣾⣿⣿⣷⡿⢿\033[1;91m⢷⡏⡈⠀⠀⠀⠀⠀⠀⠈⡹⡷⡎\033[1;96m⢸⣿⣿⣿⡇⠀⡇⠀⠸⡇⠀⠀⠀⠀⠀⠀
⠀             ⠀⠀⠀⢸⡄⠂⠖⢸⣿⣿⣿⡏⢃⠘\033[1;91m⡊⠩⠁⠀⠀⠀⠀⠀⠀⠀⠁⠀⠁\033[1;96m⢹⣿⣿⣿⡇⢰⢁⡌⢀⠇⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⠀⠀⢷⡘⠜⣤⣿⣿⣿⣷⡅⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣧⣕⣼⣠⡵⠋⠀⠀⠀⠀⠀⠀⠀
⠀⠀              ⠀⠀⠀⣸⣻⣿⣾⣿⣿⣿⣿⣾⡄⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⢀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀             ⠀⠀⡇⣿⣻⣿⣿⣿⣿⣿⣿⣿⣦⣤⣀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣳⣿⡸⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀⠀\033[1;96m⣸⢡⣿⢿⣿⣿⣿⣿⣿⣿⣿⢿⣿⡟⣽⠉⠀⠒⠂⠉⣯⢹⣿⡿⣿⣿⣿⣿⣿⣯⣿⡇⠇ ⡇ \e[32mAuthor: github.com/Azumi67  \033[1;96m⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀             ⠀\033[1;96m⢰⡏⣼⡿⣿⣻⣿⣿⣿⣿⣿⢿⣻⡿⠁⠘⡆⠀⠀⠀⢠⠇⠘⣿⣿⣽⣿⣿⣿⣿⣯⣿⣷⣸⠀⠀ ⠀⠀⠀⠀
  \033[1;96m  ______   \033[1;94m _______  \033[1;92m __    \033[1;93m  _______     \033[1;91m   __      \033[1;96m _____  ___  
 \033[1;96m  /    " \  \033[1;94m|   __ "\ \033[1;92m|" \  \033[1;93m  /"      \    \033[1;91m  /""\     \033[1;96m(\"   \|"  \ 
 \033[1;96m // ____  \ \033[1;94m(. |__) :)\033[1;92m||  |  \033[1;93m|:        |   \033[1;91m /    \   \033[1;96m |.\\   \     |
 \033[1;96m/  /    ) :)\033[1;94m|:  ____/ \033[1;92m|:  |  \033[1;93m|_____/   )  \033[1;91m /' /\  \   \033[1;96m|: \.   \\   |
\033[1;96m(: (____/ // \033[1;94m(|  /     \033[1;92m|.  |  \033[1;93m //      /  \033[1;91m //  __'  \  \033[1;96m|.  \    \  |
 \033[1;96m\        / \033[1;94m/|__/ \    \033[1;92m/\  |\ \033[1;93m|:  __   \  \033[1;91m/   /  \\   \ \033[1;96m|    \    \ |
 \033[1;96m \"_____/ \033[1;94m(_______)  \033[1;92m(__\_|_)\033[1;93m|__|  \___)\033[1;91m(___/    \___) \033[1;96m\___|\____\)
EOF
)
function main_menu() {
    while true; do
        display_logo
        echo -e "\e[93m╔════════════════════════════════════════════════════════════════╗\e[0m"  
        echo -e "\e[93m║           ▌║█║▌│║▌│║▌║▌█║ \e[92mMain Menu\e[93m  ▌│║▌║▌│║║▌█║▌             ║\e[0m"   
        echo -e "\e[93m╠════════════════════════════════════════════════════════════════╣\e[0m"                                
        echo -e "\e[93m╔════════════════════════════════════════════════════════════════╗\e[0m"
        echo -e   "\e[91m      ������ \e[92mJoin Opiran Telegram \e[34m@https://t.me/OPIranClub\e[0m \e[91m������\e[0m"
        echo -e "\e[93m╠════════════════════════════════════════════════════════════════╣\e[0m"  
		echo -e "1. \e[93mPrivate IP - [Signle Server]\e[0m"
        echo -e "2. \e[96mPrivate IP - [3]Kharej | [1]IRAN\e[0m"
		echo -e "3. \e[92mPrivate IP - [1]Kharej | [3]IRAN\e[0m"
        echo -e "4. \e[94m6to4\e[0m"
        echo -e "5. \e[93m6to4 [Anycast]\e[0m"
        echo -e "6. \e[91mUninstall\e[0m"
        echo "0. Exit"
          printf "\e[93m╰─────────────────────────────────────────────────────────────────╯\e[0m\n" 
        read -e -p $'\e[5mEnter your choice Please: \e[0m' choice

        case $choice in
		    1)
			    single_private_ip
				;;
            2)
                private_ip_3
                ;;
			3)
                private_ip_1
                ;;				
            4)
                6to4_one
                ;;
            5)
                6to4_any
                ;;
            6)
                uninstall
                ;;
            0)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac

        echo "Press Enter to continue..."
        read
        clear
    done
}
function single_private_ip() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mPrivate IP Menu[1-server]\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
      printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mChoose what to do:\e[0m'
  echo $'1. \e[92mKharej\e[0m'
  echo $'2. \e[91mIRAN\e[0m'
  echo $'3. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
    1)
        kharej_single_menu
        ;;
    2)
        iran_single_menu
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
function kharej_single_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring kharej server\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
	  display_notification $'\e[93mAdding private IP addresses for Kharej server...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address: \e[0m' remote_ip


# ip commands
ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b481::1/64"
ip addr add $initial_ip dev azumi > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"

# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi
  fi
done

    # private.sh
	display_notification $'\e[93mAdding commands to private.sh...\e[0m'
    echo "ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
    echo "ip link set dev azumi up" >> /etc/private.sh
    echo "ip addr add fd1d:fc98:b73e:b481::1/64 dev azumi" >> /etc/private.sh
        ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1/64"
        echo "ip addr add $ip_addr dev azumi" >> /etc/private.sh

    display_checkmark $'\e[92mPrivate ip added successfully!\e[0m'

display_notification $'\e[93mAdding cron job for server!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -
	
	ping -c 2 fd1d:fc98:b73e:b481::2 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
	display_notification $'\e[93mConfiguring keepalive service..\e[0m'

    # script
script_content='#!/bin/bash

# IPv6 address
ip_address="fd1d:fc98:b73e:b481::2"

# maximum number
max_pings=4

# Interval
interval=60

# Loop run
while true
do
    # Loop for pinging specified number of times
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::1"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
# private IP for Iran
function iran_single_menu() {
 clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring Iran server\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      ech0 ""
    	  display_notification $'\e[93mAdding private IP addresses for Iran server...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address: \e[0m' remote_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address: \e[0m' local_ip


# ip commands
ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b481::2/64"
ip addr add $initial_ip dev azumi > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64" > /dev/null
  
  # Check iran
  ip addr show dev azumi | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi
  fi
done
# private.sh
    echo -e "\e[93mAdding commands to private.sh...\e[0m"
    echo "ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
    echo "ip link set dev azumi up" >> /etc/private.sh
    echo "ip addr add fd1d:fc98:b73e:b481::2/64 dev azumi" >> /etc/private.sh
        ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64"
        echo "ip addr add $ip_addr dev azumi" >> /etc/private.sh
    
    chmod +x /etc/private.sh

    display_checkmark $'\e[92mPrivate ip added successfully!\e[0m'


    display_notification $'\e[93mAdding cron job for server!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -

	ping -c 2 fd1d:fc98:b73e:b481::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
	display_notification $'\e[93mConfiguring keepalive service..\e[0m'

# script
script_content='#!/bin/bash

# iPv6 address
ip_address="fd1d:fc98:b73e:b481::1"


max_pings=3

# interval
interval=50

# loop run
while true
do
    # Loop for pinging specified number of times
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'

# display
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Iran):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
function private_ip_3() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[92m[3]\e[93mKharej- \e[92m[1]\e[93mIran private ip Menu\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════════════\e[0m'
	display_logoo
  echo -e "\e[93m.------------------------------------------------------------------------------------------------------------------------------------.\e[0m"
  echo -e "\e[93m| \e[92mEstablish the tunnel on  3 different kharej server and one iran server     \e[0m"
  echo -e "\e[93m|\e[0m Make sure to use the correct kharej ipv4 addresses on iran server as well                                                             \e[0m"
    echo -e "\e[93m|\e[93m for example : if you've used kharej[1] ipv4 for kharej server 1, use the same kharej ipv4s on iran server as well.                  \e[0m"
  echo -e "\e[93m'------------------------------------------------------------------------------------------------------------------------------------'\e[0m"
      printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mChoose what to do:\e[0m'
  echo $'1. \e[92mKharej server 1\e[0m'
  echo $'2. \e[93mKharej server 2\e[0m'
  echo $'3. \e[92mKharej server 3\e[0m'
  echo $'4. \e[93mIRAN Server[3 kharej servers - 1 iran]\e[0m'
  echo $'5. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
    1)
        kharej_private_menu
        ;;
	2)
        kharej2_private_menu
        ;;
    3)
        kharej3_private_menu
        ;;
    4)
        iran_private_menu
        ;;
    5)
        clear
        main_menu
        ;;
    *)
        echo "Invalid choice."
        ;;
esac
}
function kharej_private_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring kharej server 1\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
	  display_logoo
     echo -e "\e[93m.------------------------------------------------------------------------------------------------------------------------------------.\e[0m"
     echo -e "\e[93m| \e[92mIf you have 3 different kharej servers, make a note and assing an ipv4 address for every server. eg : server 1 : kharej[1] ipv4      \e[0m"
     echo -e "\e[93m|\e[0m Since we have one iran server, it will be the same ipv4 for every kharej servers.                                                        \e[0m"
     echo -e "\e[93m|\e[93m You can enter the number of additional private IPs you may need.                              \e[0m"
     echo -e "\e[93m'------------------------------------------------------------------------------------------------------------------------------------'\e[0m"
	 display_notification $'\e[93mAdding private IP addresses for Kharej server 1...\e[0m'
	 
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej[1]\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address \e[92m[iran ipv4 address is the same for every kharej server]: \e[0m' remote_ip


# ip commands
ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null
ip link set dev azumi mtu 1480 > /dev/null
ip link set dev azumi up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b481::2/64"
ip addr add $initial_ip dev azumi > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi
  fi
done

   # private.sh
   display_notification $'\e[93mAdding commands to private.sh...\e[0m'
echo "ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
echo "ip link set dev azumi mtu 1480" >> /etc/private.sh
echo "ip link set dev azumi up" >> /etc/private.sh
echo "ip addr add fd1d:fc98:b73e:b481::2/64 dev azumi" >> /etc/private.sh
ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64"
echo "ip addr add $ip_addr dev azumi" >> /etc/private.sh

display_notification $'\e[93mIAdding cronjob for server 1!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -

	ping -c 2 fd1d:fc98:b73e:b481::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
    # script
script_content='#!/bin/bash

# IPv6 address
ip_address="fd1d:fc98:b73e:b481::1"


max_pings=3

# interval
interval=60


while true
do
    #ping
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
#kharej2
function kharej2_private_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring kharej server 2\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
    display_notification $'\e[93mAdding private IP addresses for Kharej server 2...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej[2]\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address \e[92m[iran ipv4 address is the same for every kharej server]: \e[0m' remote_ip


# ip commands
ip tunnel add azumi2 mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null
ip link set dev azumi2 mtu 1480 > /dev/null
ip link set dev azumi2 up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b381::2/64"
ip addr add $initial_ip dev azumi2 > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b38${ip_suffix}::2/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi2 | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi2
  fi
done

   # private.sh
 display_notification $'\e[93mAdding commands to private.sh...\e[0m'
echo "ip tunnel add azumi2 mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
echo "ip link set dev azumi2 mtu 1480" >> /etc/private.sh
echo "ip link set dev azumi2 up" >> /etc/private.sh
echo "ip addr add fd1d:fc98:b73e:b381::2/64 dev azumi2" >> /etc/private.sh
ip_addr="fd1d:fc98:b73e:b38${ip_suffix}::2/64"
echo "ip addr add $ip_addr dev azumi2" >> /etc/private.sh

display_notification $'\e[93mAdding cron job for server 2!\e[0m'

    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -

	ping -c 2 fd1d:fc98:b73e:b381::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
    # script
script_content='#!/bin/bash

# iPv6 address
ip_address="fd1d:fc98:b73e:b381::1"


max_pings=3

# interval
interval=50

#loop
while true
do
    # Loop for pinging specified number of times
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b38${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
#kharej3
function kharej3_private_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring kharej server 3\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
    display_notification $'\e[93mAdding private IP addresses for Kharej server 3...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej[3]\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mIRAN\e[93m IPV4 address \e[92m[iran ipv4 address is the same for every kharej server]: \e[0m' remote_ip


# ip commands
ip tunnel add azumi3 mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null
ip link set dev azumi3 mtu 1480 > /dev/null
ip link set dev azumi3 up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b281::2/64"
ip addr add $initial_ip dev azumi3 > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b28${ip_suffix}::2/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi3 | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi3
  fi
done

   # private.sh
 display_notification $'\e[93mAdding commands to private.sh...\e[0m'
echo "ip tunnel add azumi3 mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
echo "ip link set dev azumi3 mtu 1480" >> /etc/private.sh
echo "ip link set dev azumi3 up" >> /etc/private.sh
echo "ip addr add fd1d:fc98:b73e:b281::2/64 dev azumi3" >> /etc/private.sh
ip_addr="fd1d:fc98:b73e:b28${ip_suffix}::2/64"
echo "ip addr add $ip_addr dev azumi3" >> /etc/private.sh

display_notification $'\e[93mAdding cron job for server 3!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -
	ping -c 2 fd1d:fc98:b73e:b281::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	sleep 1
    # script
script_content='#!/bin/bash

# ipv6 address
ip_address="fd1d:fc98:b73e:b281::1"


max_pings=3

# interval
interval=40


while true
do
    # loop
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b28${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
# private IP for Iran
function iran_private_menu() {
    clear
echo $'\e[92m ^ ^\e[0m'
echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
echo $'\e[92m(   ) \e[93mConfiguring Iran server\e[0m'
echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
	  display_logoo
     echo -e "\e[93m.------------------------------------------------------------------------------------------------------------------------.\e[0m"
     echo -e "\e[93m| \e[92mEnter the number of your kharej servers [eg : 3].                                                 \e[0m"
	  echo -e "\e[93m|\e[93m You use the same iran ipv4 address for each kharej servers                   \e[0m"
     echo -e "\e[93m|\e[0m If you used turkey ipv4 for server 1, you should use turkey ipv4 as server 1 on iran server              \e[0m"
     echo -e "\e[93m|\e[92m You can have additional private IPs for each server if you want                              \e[0m"
     echo -e "\e[93m'------------------------------------------------------------------------------------------------------------------------'\e[0m"

display_notification $'\e[93mAdding private IP addresses for Iran server...\e[0m'

if [ -f "/etc/private_1.sh" ]; then
    rm /etc/private_1.sh
fi

if [ -f "/etc/private_2.sh" ]; then
    rm /etc/private_2.sh
fi

if [ -f "/etc/private_3.sh" ]; then
    rm /etc/private_3.sh
fi
# buffer space
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf > /dev/null
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf > /dev/null
sysctl -p > /dev/null

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter the number of your Kharej servers: \e[0m' num_servers


for ((i=1; i<=num_servers; i++))
do
    echo ""
    echo -e "\e[93mConfiguring Kharej server $i...\e[0m"

    # Set IP address based on server number
    if [ $i -eq 1 ]; then
        device_name="azumi"
        initial_ip="fd1d:fc98:b73e:b481::1/64"
        kharej_ip="fd1d:fc98:b73e:b481::2/64"
        i_ip="fd1d:fc98:b73e:b48"
    elif [ $i -eq 2 ]; then
        device_name="azumi2"
        initial_ip="fd1d:fc98:b73e:b381::1/64"
        kharej_ip="fd1d:fc98:b73e:b381::2/64"
		i_ip="fd1d:fc98:b73e:b38"
    elif [ $i -eq 3 ]; then
        device_name="azumi3"
        initial_ip="fd1d:fc98:b73e:b281::1/64"
        kharej_ip="fd1d:fc98:b73e:b281::2/64"
		i_ip="fd1d:fc98:b73e:b28"
    else
        echo "Invalid server number. Skipping..."
        continue
    fi

    sleep 1

    read -e -p $'\e[93mEnter \e[92mIran\e[93m IPV4 address [ Same iran ipv4 address]: \e[0m' local_ip
    read -p $'\e[93mEnter \e[92mKharej'"$i"$'\e[93m IPV4 address: \e[0m' remote_ip
    sleep 1

    # ip commands
    ip tunnel add $device_name mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null
	ip link set dev $device_name mtu 1480 > /dev/null
    ip link set dev $device_name up > /dev/null
    sleep 1

    # Checking
    ip addr show dev $device_name | grep -q "$initial_ip"
    if [ $? -eq 0 ]; then
        echo "IP address $initial_ip already exists. Skipping..."
    else
        ip addr add $initial_ip dev $device_name > /dev/null
    fi
    sleep 1

    # additional private IPs-number
    read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need for server '"$i"$'? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
    # additional private IPs
    for ((j=1; j<=num_ips; j++))
    do
        ip_suffix=$(printf "%x\n" $j)
        ip_addr="${i_ip}${ip_suffix}::1/64"

        # Check if IP address exists
        ip addr show dev $device_name | grep -q "$ip_addr"
        if [ $? -eq 0 ]; then
            echo "IP address $ip_addr already exists. Skipping..."
        else
            ip addr add $ip_addr dev $device_name > /dev/null
        fi
    done

    # private.sh
    echo -e "\e[93mAdding commands to private.sh for server $i...\e[0m"
    echo "ip tunnel add $device_name mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private_$i.sh
	echo "ip link set dev $device_name mtu 1480" >> /etc/private_$i.sh
    echo "ip link set dev $device_name up" >> /etc/private_$i.sh
    echo "ip addr add $initial_ip dev $device_name" >> /etc/private_$i.sh
	ip_addr="${i_ip}${ip_suffix}::1/64"
    echo "ip addr add $ip_addr dev $device_name" >> /etc/private_$i.sh
    echo ""
done

# the number of servers
num_servers=3

# Function
create_ping_files() {
    local server_number=$1
    local device_name
    local initial_ip
    local kharej_ip
    local i_ip
	local ping

    if [ $server_number -eq 1 ]; then
        device_name="azumi"
        initial_ip="fd1d:fc98:b73e:b481::1/64"
        kharej_ip="fd1d:fc98:b73e:b481::2"
        i_ip="fd1d:fc98:b73e:b48"
		ping=40
    elif [ $server_number -eq 2 ]; then
        device_name="azumi2"
        initial_ip="fd1d:fc98:b73e:b381::1/64"
        kharej_ip="fd1d:fc98:b73e:b381::2"
        i_ip="fd1d:fc98:b73e:b38"
		ping=50
    elif [ $server_number -eq 3 ]; then
        device_name="azumi3"
        initial_ip="fd1d:fc98:b73e:b281::1/64"
        kharej_ip="fd1d:fc98:b73e:b281::2"
        i_ip="fd1d:fc98:b73e:b28"
		ping=60
    else
        echo "Invalid server number. Skipping..."
        return
    fi
     # ping test
    echo -e "\e[93mPerforming ping test for Kharej server '"$server_number"$'...\e[0m"
    ping -c 2 $kharej_ip
    sleep 1
    # content
    local script_content="#!/bin/bash

# ipv6 address
ip_address=\"$kharej_ip\"


max_pings=3

# interval
interval=\"$ping\"

# loooopz
while true
do
    # loop
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=\$(ping -c 1 \$ip_address | grep \"time=\" | awk -F \"time=\" \"{print \$2}\" | awk -F \" \" \"{print \$1}\" | cut -d \".\" -f1)
        if [ -n \"\$ping_result\" ]; then
            echo \"Ping successful! Response time: \$ping_result ms\"
        else
            echo \"Ping failed!\"
        fi
    done

    echo \"Waiting for \$interval seconds...\"
    sleep \$interval
done"

    #script file
    echo "$script_content" | sudo tee "/etc/ping_$server_number.sh" > /dev/null

    chmod +x "/etc/ping_$server_number.sh"

    # service file
    local service_content="[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_$server_number.sh
Restart=always

[Install]
WantedBy=multi-user.target"

    echo "$service_content" | sudo tee "/etc/systemd/system/ping_$server_number.service" > /dev/null

  
    sudo systemctl daemon-reload

    sudo systemctl enable "ping_$server_number"
    sudo systemctl start "ping_$server_number"


    # cronjob 
	display_notification $'\e[93mAdding cron job for server '"$server_number"$'...\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private_$server_number.sh") | crontab -
	
}

# server numbers
     echo -e "\e[93m.---------------------------------------------------------------------------------------------------------.\e[0m"
     echo -e "\e[93m| \e[92mIf you have 2 servers , you should enter like this >> 1 2    - With a space between  every number                                           \e[0m"
	  echo -e "\e[0m|\e[0m If you have 3 servers, you should enter it like this >> 1 2 3  - With a space between every number                \e[0m"
     echo -e "\e[93m'---------------------------------------------------------------------------------------------------------'\e[0m"
read -e -p $'\e[93mEnter the \e[92mserver numbers \e[93m(Choose the server numbers, separated by a space - e.g., 1 2 3): \e[0m' server_numbers


IFS=' ' read -ra server_array <<< "$server_numbers"

# the input
re='^[1-9]+$'
for server_number in "${server_array[@]}"; do
    if ! [[ $server_number =~ $re ]] || [ $server_number -gt $num_servers ]; then
        echo "Invalid server number: $server_number. Skipping..."
        continue
    fi

    # Create the ping files
    create_ping_files $server_number
done

# Reload systemd configuration
sudo systemctl daemon-reload

# Enable and start the ping service
sudo systemctl enable "ping_$server_number"
sudo systemctl start "ping_$server_number"

display_checkmark $'\e[92mPing service and script files created successfully for server '"$server_number"$'.\e[0m'
}

#3iran-1Kharej
function private_ip_1() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[92m[1]\e[93mKharej - \e[92m[3]\e[93mIran private ip Menu\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════════\e[0m'
	  echo -e "\e[93m.------------------------------------------------------------------------------------------------------------------------------------.\e[0m"
  echo -e "\e[93m| \e[92mEstablish the tunnel on  3 different iran server and one kharej server        \e[0m"
  echo -e "\e[93m|\e[0m Make sure to use the correct iran ipv4 addresses on kharej server as well                                                              \e[0m"
    echo -e "\e[93m|\e[93m for example : if you've used Arvan ipv4 for iran server 1, use the same Arvan ipv4 for server 1 on kharej server           \e[0m"
  echo -e "\e[93m'------------------------------------------------------------------------------------------------------------------------------------'\e[0m"
      printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mChoose what to do:\e[0m'
  echo $'1. \e[92mIran server 1\e[0m'
  echo $'2. \e[93mIran server 2\e[0m'
  echo $'3. \e[92mIran server 3\e[0m'
  echo $'4. \e[93mKharej Server[3 Iran server- 1 Kharej]\e[0m'
  echo $'5. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
    1)
        iran1_private_menu
        ;;
	2)
        iran2_private_menu
        ;;
    3)
        iran3_private_menu
        ;;
    4)
        kharejj_private_menu
        ;;
    5)
        clear
        main_menu
        ;;
    *)
        echo "Invalid choice."
        ;;
esac
}
function iran1_private_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring Iran server 1\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      	  display_logoo
     echo -e "\e[93m.------------------------------------------------------------------------------------------------------------------------------------.\e[0m"
     echo -e "\e[93m| \e[92mIf you have 3 different iran servers, make a note and assing an ipv4 address for every server. eg : server 1 : iran[1] ipv4        \e[0m"
     echo -e "\e[93m|\e[0m Since we have one kharej server, it will be the same ipv4 for every iran servers.                                                        \e[0m"
     echo -e "\e[93m|\e[93m You can enter the number of additional private IPs you may need.                              \e[0m"
     echo -e "\e[93m'------------------------------------------------------------------------------------------------------------------------------------'\e[0m"
	display_notification $'\e[93mAdding private IP addresses for iran server 1...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mIran[1]\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address [Kharej ipv4 address is the same for every iran server]: \e[0m' remote_ip


# ip commands
ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b481::2/64"
ip addr add $initial_ip dev azumi > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi
  fi
done

   # private.sh
echo -e "\e[93mAdding commands to private.sh...\e[0m"
echo "ip tunnel add azumi mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
echo "ip link set dev azumi up" >> /etc/private.sh
echo "ip addr add fd1d:fc98:b73e:b481::2/64 dev azumi" >> /etc/private.sh
ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2/64"
echo "ip addr add $ip_addr dev azumi" >> /etc/private.sh

display_notification $'\e[93mAdding cron job for server 1...\e[0m'

    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -
	sleep 1
	ping -c 2 fd1d:fc98:b73e:b481::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 
	
    # script
script_content='#!/bin/bash

# iPv6 address
ip_address="fd1d:fc98:b73e:b481::1"


max_pings=3

# interval
interval=60


while true
do
    # ping loop
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b48${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
#kharej2
function iran2_private_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring Iran server 2\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
    display_notification $'\e[93mAdding private IP addresses for iran server 2...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mIran[2]\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address [Kharej ipv4 address is the same for every iran server]: \e[0m' remote_ip


# ip commands
ip tunnel add azumi2 mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi2 up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b381::2/64"
ip addr add $initial_ip dev azumi2 > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b38${ip_suffix}::2/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi2 | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi2
  fi
done

   # private.sh
echo -e "\e[93mAdding commands to private.sh...\e[0m"
echo "ip tunnel add azumi2 mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
echo "ip link set dev azumi2 up" >> /etc/private.sh
echo "ip addr add fd1d:fc98:b73e:b381::2/64 dev azumi2" >> /etc/private.sh
ip_addr="fd1d:fc98:b73e:b38${ip_suffix}::2/64"
echo "ip addr add $ip_addr dev azumi2" >> /etc/private.sh

display_notification $'\e[93mAdding cron job for server 2...\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -
	sleep 1
	ping -c 2 fd1d:fc98:b73e:b381::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 

    # script
script_content='#!/bin/bash

# iPv6 address
ip_address="fd1d:fc98:b73e:b381::1"


max_pings=3

# interval
interval=50


while true
do
    # ping loopz
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b38${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
#kharej3
function iran3_private_menu() {
     clear
	  echo $'\e[92m ^ ^\e[0m'
      echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
      echo $'\e[92m(   ) \e[93mConfiguring Iran server 3\e[0m'
      echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
      echo ""
    display_notification $'\e[93mAdding private IP addresses for iran server 3...\e[0m'
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mIran[3]\e[93m IPV4 address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address [Kharej ipv4 address is the same for every iran server]: \e[0m' remote_ip


# ip commands
ip tunnel add azumi3 mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null

ip link set dev azumi3 up > /dev/null
 
# iran initial IP address
initial_ip="fd1d:fc98:b73e:b281::2/64"
ip addr add $initial_ip dev azumi3 > /dev/null

# additional private IPs-number
read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
# additional private IPs
for ((i=1; i<=num_ips; i++))
do
  ip_suffix=`printf "%x\n" $i`
  ip_addr="fd1d:fc98:b73e:b28${ip_suffix}::2/64"  > /dev/null
  
  # Check kharej
  ip addr show dev azumi3 | grep -q "$ip_addr"
  if [ $? -eq 0 ]; then
    echo "IP address $ip_addr already exists. Skipping..."
  else
    ip addr add $ip_addr dev azumi3
  fi
done

   # private.sh
echo -e "\e[93mAdding commands to private.sh...\e[0m"
echo "ip tunnel add azumi3 mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private.sh
echo "ip link set dev azumi3 up" >> /etc/private.sh
echo "ip addr add fd1d:fc98:b73e:b281::2/64 dev azumi3" >> /etc/private.sh
ip_addr="fd1d:fc98:b73e:b28${ip_suffix}::2/64"
echo "ip addr add $ip_addr dev azumi3" >> /etc/private.sh

display_notification $'\e[93mAdding cron job for server 3...\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private.sh") | crontab -
	sleep 1
	ping -c 2 fd1d:fc98:b73e:b281::1 | sed "s/.*/\x1b[94m&\x1b[0m/" 
    # script
script_content='#!/bin/bash

# iPv6 address
ip_address="fd1d:fc98:b73e:b281::1"


max_pings=3

# interval
interval=40


while true
do
    # ping
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh
# service file
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service
    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'	
	
# display 
echo ""
echo -e "Created \e[93mPrivate IP Addresses \e[92m(Kharej):\e[0m"
for ((i=1; i<=num_ips; i++))
do
    ip_suffix=`printf "%x\n" $i`
    ip_addr="fd1d:fc98:b73e:b28${ip_suffix}::2"
    echo "+---------------------------+"
    echo -e "| \e[92m$ip_addr    \e[0m|"
done
echo "+---------------------------+"
}
# private IP for kharej
function kharejj_private_menu() {
    clear
echo $'\e[92m ^ ^\e[0m'
echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
echo $'\e[92m(   ) \e[93mConfiguring kharej server\e[0m'
echo $'\e[92m "-"\e[93m══════════════════════════\e[0m'
	  display_logoo
     echo -e "\e[93m.------------------------------------------------------------------------------------------------------------------------.\e[0m"
     echo -e "\e[93m| \e[92mEnter the number of your iran servers [eg : 3].                                               \e[0m"
	 echo -e "\e[93m|\e[93m You use the same kharej ipv4 address as you've entered on iran servers.                 \e[0m"
     echo -e "\e[93m|\e[0m If you used for example Arvan ipv4 as server 1. you should use Arvan ipv4 as server 1 on kharej server              \e[0m"
     echo -e "\e[93m|\e[92m You can have additional private IPs for each server if you want                              \e[0m"
     echo -e "\e[93m'------------------------------------------------------------------------------------------------------------------------'\e[0m"
	 
display_notification $'\e[93mAdding private IP addresses for Kharej servers...\e[0m'


if [ -f "/etc/private_1.sh" ]; then
    rm /etc/private_1.sh
fi

if [ -f "/etc/private_2.sh" ]; then
    rm /etc/private_2.sh
fi

if [ -f "/etc/private_3.sh" ]; then
    rm /etc/private_3.sh
fi
# buffer space
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf > /dev/null
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf > /dev/null
sysctl -p > /dev/null

# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter the number of your Iran servers: \e[0m' num_servers

# Loop for each server
for ((i=1; i<=num_servers; i++))
do
    echo ""
    echo -e "\e[93mConfiguring iran server $i...\e[0m"

    # Set IP address based on server number
    if [ $i -eq 1 ]; then
        device_name="azumi"
        initial_ip="fd1d:fc98:b73e:b481::1/64"
        iran_ip="fd1d:fc98:b73e:b481::2/64"
        i_ip="fd1d:fc98:b73e:b48"
    elif [ $i -eq 2 ]; then
        device_name="azumi2"
        initial_ip="fd1d:fc98:b73e:b381::1/64"
        iran_ip="fd1d:fc98:b73e:b381::2/64"
		i_ip="fd1d:fc98:b73e:b38"
    elif [ $i -eq 3 ]; then
        device_name="azumi3"
        initial_ip="fd1d:fc98:b73e:b281::1/64"
        iran_ip="fd1d:fc98:b73e:b281::2/64"
		i_ip="fd1d:fc98:b73e:b28"
    else
        echo "Invalid server number. Skipping..."
        continue
    fi

    sleep 1
    read -e -p $'\e[93mEnter \e[92mKharej\e[93m IPV4 address [ Same Kharej ipv4 address]: \e[0m' local_ip
    read -p $'\e[93mEnter \e[92mIran'"$i"$'\e[93m IPV4 address: \e[0m' remote_ip
    sleep 1

    # ip commands
    ip tunnel add $device_name mode sit remote $remote_ip local $local_ip ttl 255 > /dev/null
	ip link set dev $device_name mtu 1480 > /dev/null
    ip link set dev $device_name up > /dev/null
    sleep 1

    # initial IP address
    ip addr show dev $device_name | grep -q "$initial_ip"
    if [ $? -eq 0 ]; then
        echo "IP address $initial_ip already exists. Skipping..."
    else
        ip addr add $initial_ip dev $device_name > /dev/null
    fi
    sleep 1

    # additional private IPs-number
    read -e -p $'How many additional \e[92mprivate IPs\e[93m do you need for server '"$i"$'? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
    # additional private IPs
    for ((j=1; j<=num_ips; j++))
    do
        ip_suffix=$(printf "%x\n" $j)
        ip_addr="${i_ip}${ip_suffix}::1/64"

        # Check if IP address exists
        ip addr show dev $device_name | grep -q "$ip_addr"
        if [ $? -eq 0 ]; then
            echo "IP address $ip_addr already exists. Skipping..."
        else
            ip addr add $ip_addr dev $device_name > /dev/null
        fi
    done

    # private.sh
    echo -e "\e[93mAdding commands to private.sh for server $i...\e[0m"
    echo "ip tunnel add $device_name mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/private_$i.sh
	echo "ip link set dev $device_name mtu 1480" >> /etc/private_$i.sh
    echo "ip link set dev $device_name up" >> /etc/private_$i.sh
    echo "ip addr add $initial_ip dev $device_name" >> /etc/private_$i.sh
	ip_addr="${i_ip}${ip_suffix}::1/64"
    echo "ip addr add $ip_addr dev $device_name" >> /etc/private_$i.sh
    echo ""
done

# the number of servers
num_servers=3

# Function 
create_ping_files() {
    local server_number=$1
    local device_name
    local initial_ip
    local iran_ip
    local i_ip
    local ping
	
    if [ $server_number -eq 1 ]; then
        device_name="azumi"
        initial_ip="fd1d:fc98:b73e:b481::1/64"
        iran_ip="fd1d:fc98:b73e:b481::2"
        i_ip="fd1d:fc98:b73e:b48"
		ping=40
    elif [ $server_number -eq 2 ]; then
        device_name="azumi2"
        initial_ip="fd1d:fc98:b73e:b381::1/64"
        iran_ip="fd1d:fc98:b73e:b381::2"
        i_ip="fd1d:fc98:b73e:b38"
		ping=50
    elif [ $server_number -eq 3 ]; then
        device_name="azumi3"
        initial_ip="fd1d:fc98:b73e:b281::1/64"
        iran_ip="fd1d:fc98:b73e:b281::2"
        i_ip="fd1d:fc98:b73e:b28"
		ping=60
    else
        echo "Invalid server number. Skipping..."
        return
    fi
# ping test
    echo -e "\e[93mPerforming ping test for Iran server '"$server_number"$'...\e[0m"
    ping -c 2 $iran_ip
    sleep 1
    # content
    local script_content="#!/bin/bash

# IPv6 address
ip_address=\"$iran_ip\"


max_pings=3

# interval
interval=\"$ping\"

# loop
while true
do
    # Loop 
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=\$(ping -c 1 \$ip_address | grep \"time=\" | awk -F \"time=\" \"{print \$2}\" | awk -F \" \" \"{print \$1}\" | cut -d \".\" -f1)
        if [ -n \"\$ping_result\" ]; then
            echo \"Ping successful! Response time: \$ping_result ms\"
        else
            echo \"Ping failed!\"
        fi
    done

    echo \"Waiting for \$interval seconds...\"
    sleep \$interval
done"

    # script file
    echo "$script_content" | sudo tee "/etc/ping_$server_number.sh" > /dev/null

    chmod +x "/etc/ping_$server_number.sh"

    local service_content="[Unit]
Description=keepalive
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_$server_number.sh
Restart=always

[Install]
WantedBy=multi-user.target"

    echo "$service_content" | sudo tee "/etc/systemd/system/ping_$server_number.service" > /dev/null


    sudo systemctl daemon-reload

    sudo systemctl enable "ping_$server_number"
    sudo systemctl start "ping_$server_number"


    # cronjob
	display_notification $'\e[93mAdding cron job for server '"$server_number"$'...\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/private_$server_number.sh") | crontab -
	
}

# server numbers
     echo -e "\e[93m.---------------------------------------------------------------------------------------------------------.\e[0m"
     echo -e "\e[93m| \e[92mIf you have 2 servers , you should enter like this >> 1 2    - With a space between  every number                                           \e[0m"
	  echo -e "\e[0m|\e[0m If you have 3 servers, you should enter it like this >> 1 2 3  - With a space between every number                \e[0m"
     echo -e "\e[93m'---------------------------------------------------------------------------------------------------------'\e[0m"
	 echo ""
read -e -p $'\e[93mEnter the \e[92mserver numbers \e[93m(Choose the server numbers, separated by a space - e.g., 1 2 3): \e[0m' server_numbers

# array of server numbers
IFS=' ' read -ra server_array <<< "$server_numbers"

#input
re='^[1-9]+$'
for server_number in "${server_array[@]}"; do
    if ! [[ $server_number =~ $re ]] || [ $server_number -gt $num_servers ]; then
        echo "Invalid server number: $server_number. Skipping..."
        continue
    fi

    # ping
    create_ping_files $server_number
done

sudo systemctl daemon-reload

# service
sudo systemctl enable "ping_$server_number"
sudo systemctl start "ping_$server_number"

display_checkmark $'\e[92mPing service and script files created successfully for server '"$server_number"$'.\e[0m'
	
}
function 6to4_one() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93m6to4 Menu\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════\e[0m'
      printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mChoose what to do:\e[0m'
  echo $'1. \e[92mKharej Server \e[0m'
  echo $'2. \e[93mIRAN Server\e[0m'
  echo $'3. \e[94mback to main menu\e[0m'
  printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
    1)
        6to4_kharej
        ;;
    2)
        6to4_iran
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
function 6to4_kharej() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93m6to4 Kharej Menu\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════\e[0m'
    
    if [ -f "/etc/6to4" ]; then
        rm /etc/6to4.sh
    fi
    
    # Q&A
    printf "\e[93m╭─────────────────────────────────────────────────╮\e[0m\n"
    read -e -p $'\e[93mEnter \e[92mKharej IPv4\e[93m address: \e[0m' local_ip
    read -e -p $'\e[93mEnter \e[92mIran IPv4\e[93m address: \e[0m' remote_ip
    
    # IPv4 address
    ipv4=$(curl -s https://api.ipify.org)
    
    # prefix
    prefix=$(printf "2002:%02x%02x:%02x%02x::1" $(echo $ipv4 | tr "." " "))
    # gateway
    gateway=""
    if [[ $prefix == *::1 ]]; then
        gateway="${prefix%::1}::2"
    else
        gateway="${prefix%::1}::1"
    fi
    # masir /etc
    echo "#!/bin/bash" > /etc/6to4.sh
    echo "/sbin/modprobe sit" >> /etc/6to4.sh
    echo "/sbin/ip tunnel add azumi6 mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/6to4.sh
    echo "/sbin/ip -6 link set dev azumi6 mtu 1480" >> /etc/6to4.sh
    echo "/sbin/ip link set dev azumi6 up" >> /etc/6to4.sh
    echo "/sbin/ip -6 addr add $prefix/16 dev azumi6" >> /etc/6to4.sh
    echo "/sbin/ip -6 route add 2000::/3 via $gateway dev azumi6 metric 1" >> /etc/6to4.sh
    echo "ip -6 route add $gateway dev azumi6 metric 1" >> /etc/6to4.sh
    echo "ip -6 route add ::/0 dev azumi6" >> /etc/6to4.sh
    
    read -e -p $'\e[93mHow many additional IPs do you need? \e[0m' num_ips
    printf "\e[93m╰─────────────────────────────────────────────────────╯\e[0m\n"
    
    # additional IP addresses
    start_index=3
    
    # 6to4 IP addresses
    for ((i = start_index; i <= start_index + num_ips - 1; i++))
    do
        ip_addr=$(printf "2002:%02x%02x:%02x%02x::%02x/16" $(echo $ipv4 | tr "." " ") $i)
        echo "ip -6 addr add $ip_addr dev azumi6" >> /etc/6to4.sh
    done
    
    display_notification $'\e[93mAdding cron job!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/6to4.sh") | crontab -
    
	  #  6to4.sh
    display_notification $'\e[93mStarting 6to4.sh...\e[0m'
    /bin/bash /etc/6to4.sh
    # IPv4 address
    read -e -p $'\e[93mEnter \e[92mIran IPv4\e[93m address [Ping Service]: \e[0m' remote_ipv4
    
    # the remote prefix
    remote_prefix=$(printf "2002:%02x%02x:%02x%02x::1" $(echo $remote_ipv4 | tr "." " "))
    sleep 1
	# Ping 
    ping_result=$(ping6 -c 2 $remote_prefix)

    # Display the ping result
    echo "$ping_result"
    # script
    script_content='#!/bin/bash

# IPv6 address
ip_address="'$remote_prefix'"

max_pings=3

# interval 
interval=60

# infinite loop
while true
do
    # ping loop 
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
       
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

    # /etc/ping_v6.sh
    echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh

    # ping script
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=Ping Service
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service

    display_checkmark $'\e[92mPing Service has been added successfully!\e[0m'
}
function 6to4_iran() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93m6to4 Iran Menu\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════\e[0m'
if [ -f "/etc/6to4" ]; then
        rm /etc/6to4.sh
    fi
# Q&A
printf "\e[93m╭──────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mIran IPv4\e[93m address: \e[0m' local_ip
read -e -p $'\e[93mEnter \e[92mKharej IPv4\e[93m address: \e[0m' remote_ip

# IPv4 address
ipv4=$(curl -s https://api.ipify.org)

# prefix
prefix=$(printf "2002:%02x%02x:%02x%02x::1" $(echo $ipv4 | tr "." " "))
# gaaateway
gateway=""
if [[ $prefix == *::1 ]]; then
  gateway="${prefix%::1}::2"
else
  gateway="${prefix%::1}::1"
fi
# masir /etc
echo "#!/bin/bash" > /etc/6to4.sh
echo "/sbin/modprobe sit" >> /etc/6to4.sh
echo "/sbin/ip tunnel add azumi6 mode sit remote $remote_ip local $local_ip ttl 255" >> /etc/6to4.sh
echo "/sbin/ip -6 link set dev azumi6 mtu 1480" >> /etc/6to4.sh
echo "/sbin/ip link set dev azumi6 up" >> /etc/6to4.sh
echo "/sbin/ip -6 addr add $prefix/16 dev azumi6" >> /etc/6to4.sh
echo "/sbin/ip -6 route add 2000::/3 via $gateway dev azumi6 metric 1" >> /etc/6to4.sh
echo "ip -6 route add $gateway dev azumi6 metric 1" >> /etc/6to4.sh
echo "ip -6 route add ::/0 dev azumi6" >> /etc/6to4.sh

read -e -p $'\e[93mHow many additional IPs do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────╯\e[0m\n"
# additional IP addresses
    start_index=3
    
    # 6to4 IP addresses
    for ((i = start_index; i <= start_index + num_ips - 1; i++))
    do
        ip_addr=$(printf "2002:%02x%02x:%02x%02x::%02x/16" $(echo $ipv4 | tr "." " ") $i)
        echo "ip -6 addr add $ip_addr dev azumi6" >> /etc/6to4.sh
    done
    
    display_notification $'\e[93mAdding cron job!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/6to4.sh") | crontab -
    
	  #  6to4.sh
    display_notification $'\e[93mStarting 6to4.sh...\e[0m'
    /bin/bash /etc/6to4.sh

# IPv4 address
read -e -p $'\e[93mEnter \e[92mKharej IPv4\e[93m address [Ping Service]: \e[0m' remote_ipv4

# the remote prefix
remote_prefix=$(printf "2002:%02x%02x:%02x%02x::1" $(echo $remote_ipv4 | tr "." " "))
 sleep 1
	# Ping 
    ping_result=$(ping6 -c 2 $remote_prefix)

    # Display the ping result
    echo "$ping_result"
# script
script_content='#!/bin/bash

# IPv6 address
ip_address="'$remote_prefix'"


max_pings=3

# interval
interval=50


while true
do
    # ping
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
       
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

# /etc/ping_v6.sh
echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null


chmod +x /etc/ping_v6.sh

# service file
cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=Ping Service
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable ping_v6.service
systemctl start ping_v6.service

display_checkmark $'\e[92m6to4 Service has been added successfully!\e[0m'
}
function 6to4_any() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93m6to4 \e[92mAnycast\e[93m Menu\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════\e[0m'
    
    printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
    echo $'\e[93mChoose what to do:\e[0m'
    echo $'1. \e[92mKharej server 1\e[0m'
    echo $'2. \e[93mIRAN Server\e[0m'
    echo $'3. \e[94mback to main menu\e[0m'
    printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"
    
    read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
    
    case $server_type in
        1)
            6to4_any_kharej
            ;;
        2)
            6to4_any_iran
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

function 6to4_any_kharej() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93m6to4 Kharej  Menu\e[92m[Anycast]\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════\e[0m'
if [ -f "/etc/6to4-any" ]; then
        rm /etc/6to4-any.sh
    fi
# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mKharej IPv4\e[93m address: \e[0m' local_ip

# IPv4 address
ipv4=$(curl -s https://api.ipify.org)

# prefix
prefix=$(printf "2002:%02x%02x:%02x%02x::1" $(echo $ipv4 | tr "." " "))

# masir /etc
echo "#!/bin/bash" > /etc/6to4.sh
echo "/sbin/modprobe sit" >> /etc/6to4.sh
echo "/sbin/ip tunnel add azumi6 mode sit remote any local $local_ip ttl 255" >> /etc/6to4.sh
echo "/sbin/ip -6 link set dev azumi6 mtu 1480" >> /etc/6to4.sh
echo "/sbin/ip link set dev azumi6 up" >> /etc/6to4.sh
echo "/sbin/ip -6 addr add $prefix/16 dev azumi6" >> /etc/6to4.sh
echo "/sbin/ip -6 route add 2000::/3 via ::192.88.99.1 dev azumi6 metric 1" >> /etc/6to4.sh

read -e -p $'\e[93mHow many additional IPs do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
 #additional IP addresses
    start_index=3
    
    # 6to4 IP addresses
    for ((i = start_index; i <= start_index + num_ips - 1; i++))
    do
        ip_addr=$(printf "2002:%02x%02x:%02x%02x::%02x/16" $(echo $ipv4 | tr "." " ") $i)
        echo "ip -6 addr add $ip_addr dev azumi6" >> /etc/6to4.sh
    done
    
    display_notification $'\e[93mAdding cron job!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/6to4.sh") | crontab -
    
	  #  6to4.sh
    display_notification $'\e[93mStarting 6to4.sh...\e[0m'
    /bin/bash /etc/6to4.sh
    # IPv4 address
    read -e -p $'\e[93mEnter \e[92mIran IPv4\e[93m address [Ping Service]: \e[0m' remote_ipv4
    
    # the remote prefix
    remote_prefix=$(printf "2002:%02x%02x:%02x%02x::1" $(echo $remote_ipv4 | tr "." " "))
     sleep 1
	# Ping 
    ping_result=$(ping6 -c 2 $remote_prefix)

    # Display the ping result
    echo "$ping_result"
    # script
    script_content='#!/bin/bash

# IPv6 address
ip_address="'$remote_prefix'"

max_pings=3

# interval 
interval=60

# infinite loop
while true
do
    # ping loop 
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
       
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

    # /etc/ping_v6.sh
    echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh

    # ping script
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=Ping Service
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service

    display_checkmark $'\e[92m6to4 Service has been added successfully!\e[0m'
}

function 6to4_any_iran() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93m6to4 Iran  Menu\e[92m[Anycast]\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════\e[0m'
if [ -f "/etc/6to4-any" ]; then
        rm /etc/6to4-any.sh
    fi
# Q&A
printf "\e[93m╭─────────────────────────────────────────────────────────╮\e[0m\n"
read -e -p $'\e[93mEnter \e[92mIran IPv4\e[93m address: \e[0m' local_ip


# IPv4 address
ipv4=$(curl -s https://api.ipify.org)

# prefix
prefix=$(printf "2002:%02x%02x:%02x%02x::1" $(echo $ipv4 | tr "." " "))

# masir /etc
echo "#!/bin/bash" > /etc/6to4.sh
echo "/sbin/modprobe sit" >> /etc/6to4.sh
echo "/sbin/ip tunnel add azumi6 mode sit remote any local $local_ip ttl 255" >> /etc/6to4.sh
echo "/sbin/ip -6 link set dev azumi6 mtu 1480" >> /etc/6to4.sh
echo "/sbin/ip link set dev azumi6 up" >> /etc/6to4.sh
echo "/sbin/ip -6 addr add $prefix/16 dev azumi6" >> /etc/6to4.sh
echo "/sbin/ip -6 route add 2000::/3 via ::192.88.99.1 dev azumi6 metric 1" >> /etc/6to4.sh

read -e -p $'\e[93mHow many additional IPs do you need? \e[0m' num_ips
printf "\e[93m╰─────────────────────────────────────────────────────────╯\e[0m\n"
#additional IP addresses
    start_index=3
    
    # 6to4 IP addresses
    for ((i = start_index; i <= start_index + num_ips - 1; i++))
    do
        ip_addr=$(printf "2002:%02x%02x:%02x%02x::%02x/16" $(echo $ipv4 | tr "." " ") $i)
        echo "ip -6 addr add $ip_addr dev azumi6" >> /etc/6to4.sh
    done
    
    display_notification $'\e[93mAdding cron job!\e[0m'
    (crontab -l 2>/dev/null; echo "@reboot /bin/bash /etc/6to4.sh") | crontab -
    
	  #  6to4.sh
    display_notification $'\e[93mStarting 6to4.sh...\e[0m'
    /bin/bash /etc/6to4.sh
    # IPv4 address
    read -e -p $'\e[93mEnter \e[92mKharej IPv4\e[93m address [Ping Service]: \e[0m' remote_ipv4
    
    # the remote prefix
    remote_prefix=$(printf "2002:%02x%02x:%02x%02x::1" $(echo $remote_ipv4 | tr "." " "))
    sleep 1
	# Ping 
    ping_result=$(ping6 -c 2 $remote_prefix)

    # Display the ping result
    echo "$ping_result"
    # script
    script_content='#!/bin/bash

# IPv6 address
ip_address="'$remote_prefix'"

max_pings=3

# interval 
interval=60

# infinite loop
while true
do
    # ping loop 
    for ((i = 1; i <= max_pings; i++))
    do
        ping_result=$(ping -c 1 $ip_address | grep "time=" | awk -F "time=" "{print $2}" | awk -F " " "{print $1}" | cut -d "." -f1)
       
        if [ -n "$ping_result" ]; then
            echo "Ping successful! Response time: $ping_result ms"
        else
            echo "Ping failed!"
        fi
    done

    echo "Waiting for $interval seconds..."
    sleep $interval
done'

    # /etc/ping_v6.sh
    echo "$script_content" | sudo tee /etc/ping_v6.sh > /dev/null

    chmod +x /etc/ping_v6.sh

    # ping script
    cat <<EOF > /etc/systemd/system/ping_v6.service
[Unit]
Description=Ping Service
After=network.target

[Service]
ExecStart=/bin/bash /etc/ping_v6.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable ping_v6.service
    systemctl start ping_v6.service

    display_checkmark $'\e[92m6to4 Service has been added successfully!\e[0m'
}
function uninstall() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mUninstall Menu\e[0m'
    echo $'\e[92m "-"\e[93m═════════════════════\e[0m'
	echo ""
	printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
  echo $'\e[93mSelect what to uninstall:\e[0m'
  echo $'1. \e[0mPrivate IP - [Single Server]\e[0m'
  echo $'2. \e[92mPrivate IP - [3]Kharej [1]Iran\e[0m'
  echo $'3. \e[93mPrivate IP - [1]Kharej [3]Iran\e[0m'
  echo $'4. \e[91m6to4\e[0m'
  echo $'5. \e[92m6to4 [Anycast]\e[0m'
  echo $'6. \e[94mback to main menu\e[0m'
	printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"

  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
        1)
            uninstall_single_menu
            ;;
        2)
            pri_uninstall_menu
            ;;
        3)
            prii_uninstall_menu
            ;;
		4)  
		    6t04_uninstall_menu
            ;;		
		5)
            6to44_uni
            ;;			
        6)
            clear            
            main_menu
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}
function uninstall_single_menu() {
    echo -e "\e[93mRemoving private IP addresses...\e[0m"
    if [ -f "/etc/private.sh" ]; then
        rm /etc/private.sh
    fi
    display_notification $'\e[93mRemoving cron job..\e[0m'
    crontab -l | grep -v "@reboot /bin/bash /etc/private.sh" | crontab -
 
		sleep 1
		systemctl disable ping_v6.service > /dev/null 2>&1
        systemctl stop ping_v6.service > /dev/null 2>&1
		rm /etc/systemd/system/ping_v6.service > /dev/null 2>&1
        sleep 1

    systemctl daemon-reload

    ip link set dev azumi down > /dev/null
    ip tunnel del azumi > /dev/null
	echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

    display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
function pri_uninstall_menu() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mUninstall Menu \e[92m[3]\e[93mkharej \e[92m[1]\e[93miran\e[0m'
    echo $'\e[92m "-"\e[93m═══════════════════════════════════\e[0m'
	echo ""
	printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
   echo $'\e[93mSelect what to uninstall:\e[0m'
   echo $'1. \e[92mIran\e[0m'
   echo $'2. \e[93mKharej servers\e[0m'
   echo $'3. \e[94mback to previous menu\e[0m'
	printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"

  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
        1)
            pri_iran_menu
            ;;
        2)
            prii_kharej_menu
            ;;		
        3)
            clear            
            uninstall
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}
function pri_iran_menu() {
	display_notification $'\e[93mRemoving private IP addresses...\e[0m'

	rm /etc/private_1.sh >/dev/null 2>&1
	rm /etc/private_2.sh >/dev/null 2>&1
	rm /etc/private_3.sh >/dev/null 2>&1
	sleep 1
	rm /etc/ping_1.sh >/dev/null 2>&1
	rm /etc/ping_2.sh >/dev/null 2>&1
	rm /etc/ping_3.sh >/dev/null 2>&1
	
	display_notification $'\e[93mRemoving cron job..\e[0m'
	crontab -l | grep -v "@reboot /bin/bash /etc/private_1.sh" | crontab -
	crontab -l | grep -v "@reboot /bin/bash /etc/private_2.sh" | crontab -
	crontab -l | grep -v "@reboot /bin/bash /etc/private_3.sh" | crontab -
	sleep 1
	
	systemctl disable ping_1.service >/dev/null 2>&1
	systemctl disable ping_2.service >/dev/null 2>&1
	systemctl disable ping_3.service >/dev/null 2>&1
	systemctl stop ping_1.service >/dev/null 2>&1
	systemctl stop ping_2.service >/dev/null 2>&1
	systemctl stop ping_3.service >/dev/null 2>&1
	
	rm /etc/systemd/system/ping_1.service >/dev/null 2>&1
	rm /etc/systemd/system/ping_2.service >/dev/null 2>&1
	rm /etc/systemd/system/ping_3.service >/dev/null 2>&1
	sleep 1

	systemctl daemon-reload

	ip link set dev azumi down >/dev/null 2>&1
	ip tunnel del azumi >/dev/null 2>&1
	ip link set dev azumi2 down >/dev/null 2>&1
	ip tunnel del azumi2 >/dev/null 2>&1
	ip link set dev azumi3 down >/dev/null 2>&1
	ip tunnel del azumi3 >/dev/null 2>&1

	echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

	display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
function prii_kharej_menu() {
    display_notification $'\e[93mRemoving private IP addresses...\e[0m'
    if [ -f "/etc/private.sh" ]; then
    rm /etc/private.sh
fi
sleep 1

rm /etc/ping_v6.sh > /dev/null 2>&1
display_notification $'\e[93mRemoving cron job..\e[0m'
crontab -l | grep -v "@reboot /bin/bash /etc/private.sh" | crontab -

    sleep 1
    systemctl disable ping_v6.service > /dev/null 2>&1
    systemctl stop ping_v6.service > /dev/null 2>&1
    rm /etc/systemd/system/ping_v6.service > /dev/null 2>&1
    sleep 1

    systemctl daemon-reload

    ip link set dev azumi down > /dev/null
    ip tunnel del azumi > /dev/null
	ip link set dev azumi2 down > /dev/null
    ip tunnel del azumi2 > /dev/null
	ip link set dev azumi3 down > /dev/null
    ip tunnel del azumi3 > /dev/null

	echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

    display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
function prii_uninstall_menu() {
    clear
    echo $'\e[92m ^ ^\e[0m'
    echo $'\e[92m(\e[91mO,O\e[92m)\e[0m'
    echo $'\e[92m(   ) \e[93mUninstall Menu \e[92m[1]\e[93mkharej \e[92m[3]\e[93miran\e[0m'
    echo $'\e[92m "-"\e[93m════════════════════════════════════\e[0m'
	echo ""
	printf "\e[93m╭───────────────────────────────────────╮\e[0m\n"
   echo $'\e[93mSelect what to uninstall:\e[0m'
   echo $'1. \e[92mIran servers\e[0m'
   echo $'2. \e[93mKharej\e[0m'
   echo $'3. \e[94mback to previous menu\e[0m'
	printf "\e[93m╰───────────────────────────────────────╯\e[0m\n"

  read -e -p $'\e[38;5;205mEnter your choice Please: \e[0m' server_type
case $server_type in
        1)
            priii_iran_menu
            ;;
        2)
            priii_kharej_menu
            ;;		
        3)
            clear            
            uninstall
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}
function priii_kharej_menu() {
    display_notification $'\e[93mRemoving private IP addresses...\e[0m'

	rm /etc/private_1.sh >/dev/null 2>&1
	rm /etc/private_2.sh >/dev/null 2>&1
	rm /etc/private_3.sh >/dev/null 2>&1
	sleep 1
	rm /etc/ping_1.sh >/dev/null 2>&1
	rm /etc/ping_2.sh >/dev/null 2>&1
	rm /etc/ping_3.sh >/dev/null 2>&1
	
	display_notification $'\e[93mRemoving cron job..\e[0m'
	crontab -l | grep -v "@reboot /bin/bash /etc/private_1.sh" | crontab -
	crontab -l | grep -v "@reboot /bin/bash /etc/private_2.sh" | crontab -
	crontab -l | grep -v "@reboot /bin/bash /etc/private_3.sh" | crontab -
	sleep 1
	
	systemctl disable ping_1.service >/dev/null 2>&1
	systemctl disable ping_2.service >/dev/null 2>&1
	systemctl disable ping_3.service >/dev/null 2>&1
	systemctl stop ping_1.service >/dev/null 2>&1
	systemctl stop ping_2.service >/dev/null 2>&1
	systemctl stop ping_3.service >/dev/null 2>&1
	
	rm /etc/systemd/system/ping_1.service >/dev/null 2>&1
	rm /etc/systemd/system/ping_2.service >/dev/null 2>&1
	rm /etc/systemd/system/ping_3.service >/dev/null 2>&1
	sleep 1

	systemctl daemon-reload

	ip link set dev azumi down >/dev/null 2>&1
	ip tunnel del azumi >/dev/null 2>&1
	ip link set dev azumi2 down >/dev/null 2>&1
	ip tunnel del azumi2 >/dev/null 2>&1
	ip link set dev azumi3 down >/dev/null 2>&1
	ip tunnel del azumi3 >/dev/null 2>&1

	echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

	display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
function priii_iran_menu() {
    display_notification $'\e[93mRemoving private IP addresses...\e[0m'
    if [ -f "/etc/private.sh" ]; then
    rm /etc/private.sh
fi
sleep 1

rm /etc/ping_v6.sh > /dev/null 2>&1
display_notification $'\e[93mRemoving cron job..\e[0m'
crontab -l | grep -v "@reboot /bin/bash /etc/private.sh" | crontab -
crontab -l | grep -v "@reboot /bin/bash /etc/private_2.sh" | crontab -
crontab -l | grep -v "@reboot /bin/bash /etc/private_3.sh" | crontab - 
    sleep 1
    systemctl disable ping_v6.service > /dev/null 2>&1
    systemctl stop ping_v6.service > /dev/null 2>&1
    rm /etc/systemd/system/ping_v6.service > /dev/null 2>&1
    sleep 1

    systemctl daemon-reload

    ip link set dev azumi down > /dev/null
    ip tunnel del azumi > /dev/null
	ip link set dev azumi2 down > /dev/null
    ip tunnel del azumi2 > /dev/null
	ip link set dev azumi3 down > /dev/null
    ip tunnel del azumi3 > /dev/null

	echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

    display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
function 6t04_uninstall_menu() {
display_notification $'\e[93mRemoving 6to4...\e[0m'
    if [ -f "/etc/6to4.sh" ]; then
    rm /etc/6to4.sh
fi
sleep 1

rm /etc/ping_v6.sh > /dev/null 2>&1
display_notification $'\e[93mRemoving cron job..\e[0m'
crontab -l | grep -v "@reboot /bin/bash /etc/6to4.sh" | crontab -

    sleep 1
    systemctl disable ping_v6.service > /dev/null 2>&1
    systemctl stop ping_v6.service > /dev/null 2>&1
    rm /etc/systemd/system/ping_v6.service > /dev/null 2>&1
    sleep 1

    systemctl daemon-reload

    ip link set dev azumi6 down > /dev/null
    ip tunnel del azumi6 > /dev/null

	echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

    display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
function 6to44_uni() {
display_notification $'\e[93mRemoving 6to4...\e[0m'
    if [ -f "/etc/6to4.sh" ]; then
    rm /etc/6to4.sh
fi
sleep 1

rm /etc/ping_v6.sh > /dev/null 2>&1
display_notification $'\e[93mRemoving cron job..\e[0m'
crontab -l | grep -v "@reboot /bin/bash /etc/6to4.sh" | crontab -

    sleep 1
    systemctl disable ping_v6.service > /dev/null 2>&1
    systemctl stop ping_v6.service > /dev/null 2>&1
    rm /etc/systemd/system/ping_v6.service > /dev/null 2>&1
    sleep 1

    systemctl daemon-reload

    ip link set dev azumi6 down > /dev/null
    ip tunnel del azumi6 > /dev/null

 	echo -n "Progress: "

	local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
	local delay=0.1
	local duration=3  # Duration in seconds

	local end_time=$((SECONDS + duration))

	while ((SECONDS < end_time)); do
		for frame in "${frames[@]}"; do
			printf "\r[%s] Loading...  " "$frame"
			sleep "$delay"
			printf "\r[%s]             " "$frame"
			sleep "$delay"
		done
	done

    display_checkmark $'\e[92mPrivate IP removed successfully!\e[0m'
}
#call
main_menu
