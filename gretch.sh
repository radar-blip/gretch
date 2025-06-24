#/bin/bash
# gretch 
# system info gathering script

bold=$(tput bold)
normal=$(tput sgr0)

clear
printf "${bold}"

who=$(id -u -n)
where=$(hostname)
printf '%s' "$who" "@" 
printf "$where\n" 
printf "$who" | tr "$who" '-' 
printf "$where" | tr "$where" '-' | awk '{print $0"-"}'
printf "\n"

#for extracting OS/version
. /etc/os-release

#OS name (extracted from etc/os-release)
printf "OS:%-9s" ; printf "$NAME\n"

#OS version/codename
printf "Version:%-4s" ; printf "$VERSION\n"

#desktop environment
printf "DE:%-9s" ; printf "$XDG_CURRENT_DESKTOP\n" | tr -d 'X-'

#kernel
printf "Kernel:%-5s" ; uname -r

#uptime
printf "Uptime:%-5s" ; uptime -p | cut -b 4-

#shell/version
(printf "Shell:%-6s" ; ps -o fname --no-headers $$
printf $BASH_VERSION | cut -b 1-6) | tr '\n' ' ' ; printf "\n"


#WM (window manager)
printf "WM:%-8s" ; wmctrl -m | grep Name | cut -d: -f2

#wm theme (desktop)
printf "WM Theme:%-3s" ; gsettings get org.cinnamon.theme name | tr -d "''"

#theme
printf "Theme:%-4s" ; gtk-query-settings theme | grep 'gtk-theme-name' | cut -f 2 -d ":" | tr '\n"'  ' ' ; printf "\b[GTK2/3]\n" 
#icons 
printf "Icons:%-4s" ; gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -f 2 -d ":" | tr '\n"'  ' ' ; printf "\b[GTK2/3]\n"


#resolution
printf "Resolution:%-1s" ; xdpyinfo | awk '/dimensions/ {print $2}'

#packages
(printf "Packages:%-3s" ; dpkg --get-selections | wc --lines ; printf "(dpkg), "
                          flatpak list | wc -l ; printf "(flatpak)") | tr '\n' ' ' ; printf "\n"


#CPU (short output)
#uses OR operator (||) will output long version if short fails
(printf "CPU:%-8s" ; lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1' | sed 's/w.*//' | tr '\n' ' '
                     lscpu | grep 'max' | cut -f 2 -d ":" | awk '{$1=$1}1' | awk '{printf "\b@ " substr($0, 1, length($0)-5)}' ; printf " Mhz") | tr '\n' ' ' ; printf "\n" ||

#CPU (long output)
(printf "CPU:%-8s" ; lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1')


#GPU (short output)
#uses OR operator (||) will output long version if short fails
(printf "GPU:%-7s" ; lspci | grep 'VGA' | cut -d "." -f3 | tr -d "[]") ||

#GPU (long output)
(printf "GPU:%-7s" ; lspci | grep 'VGA' | cut -d ":" -f3 | tr -d "[]")


#memory (in mebibytes)
(printf "Memory:%-5s" ; free -m | grep -oP '\d+' | sed '1!d' ; printf "MiB(total), " 
                        free -m | grep -oP '\d+' | sed '2!d' ; printf "MiB(used) ") | tr '\n' ' ' ; printf "\n"
printf "${normal}\n"
