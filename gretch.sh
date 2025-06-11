#/bin/bash
# sinfo (system info)

bold=$(tput bold)
normal=$(tput sgr0)

clear
printf "${bold}System Information\n"
printf '\b------------------\n\n'

#for extracting OS/version
. /etc/os-release

#get OS name (extracted from etc/os-release)
printf "OS:%-9s" ; printf "$NAME\n"

#get OS version\codename
printf "Version:%-4s" ; printf "$VERSION\n"

#get desktop environment
printf "DE:%-9s" ; printf "$XDG_CURRENT_DESKTOP\n" | tr -d 'X-'

#get kernel
printf "Kernel:%-5s" ; uname -r

#get uptime
printf "Uptime:%-5s" ; uptime -p | cut -b 4-

#get shell and version
(printf "Shell:%-6s" ; ps -o fname --no-headers $$
printf $BASH_VERSION | cut -b 1-6) | tr '\n' ' '

#get wm (window management)
printf "\nWM:%-8s" ; wmctrl -m | grep Name | cut -d: -f2

#get wm theme
printf "WM Theme:%-3s" ; gsettings get org.cinnamon.theme name | tr -d "''"

#get desktop theme
printf "Theme:%-6s" ; gsettings get org.cinnamon.desktop.wm.preferences theme | tr -d "''"

#get resolution
printf "Resolution:%-1s" ; xdpyinfo | awk '/dimensions/ {print $2}'


#these two commands are combined
#dpkg packages (installed)
(printf "Packages:%-3s"  ; dpkg --get-selections | wc --lines && printf "(dpkg), "

#flatpak packages
flatpak list | wc -l && printf "(flatpak)") | tr '\n' ' '


#get CPU
printf "\nCPU:%-8s" ; lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1'

#get GPU
printf "GPU:%-7s" ; lspci | grep 'VGA' | cut -d ":" -f3 | tr -d "[]"

#get local IP
printf "Local IP:%-3s" ; hostname -I | cut -f1 -d' '

printf "${normal}\n"
