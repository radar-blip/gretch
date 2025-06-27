#/bin/bash
# gretch 
# system info gathering script

bold=$(tput bold)
normal=$(tput sgr0)

clear
printf "${bold}"

who=$(id -u -n)
where=$(hostname)
printf '%s' "$who" "@" "$where" 
printf '%s' "$who" | tr "$who" '\n-' 
printf '%s' "$where" | tr "$where" '-' | awk '{print $0"--"}'
printf "\n"


#OS name/version
printf "OS:%-9s" ; cat /etc/lsb-release | grep 'DISTRIB_DESCRIPTION' | cut -f 2 -d '"'

#desktop environment
printf "DE:%-9s$XDG_CURRENT_DESKTOP\n" | tr -d 'X-'

#kernel
printf "Kernel:%-5s" ; uname -r

#uptime
printf "Uptime:%-5s" ; uptime -p | cut -b 4-

#shell/version
(printf "Shell:%-6s" ; ps -o fname --no-headers $$
printf "$BASH_VERSION" | cut -b 1-6) | tr '\n' ' ' ; printf "\n"


#WM (window manager)
printf "WM:%-8s" ; wmctrl -m | grep Name | cut -d: -f2

#theme
printf "Theme:%-4s" ; gtk-query-settings theme | grep 'gtk-theme-name' | cut -f 2 -d ":" | tr '\n"' ' ' ; printf "\b[GTK2/3]\n" 

#icons 
printf "Icons:%-4s" ; gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -f 2 -d ":" | tr '\n"' ' ' ; printf "\b[GTK2/3]\n"

#desktop theme
printf "Desktop:%-4s" ; gsettings get org.cinnamon.theme name | tr -d "''"


#resolution
printf "Resolution:%-1s" ; xdpyinfo | awk '/dimensions/ {print $2}'

#packages
if [ "flatpak list | wc -l < 1" ] 
then
    printf "Packages:%-3s" ; dpkg --get-selections | wc -l | tr '\n' ' ' ; printf "(dpkg)" ; printf "\n"
    
else
    (printf "Packages:%-3s" ; dpkg --get-selections | wc -l ; printf "(dpkg), "
                              flatpak list | wc -l ; printf "(flatpak)") | tr '\n' ' ' ; printf "\n"
fi


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
                        free -m | grep -oP '\d+' | sed '2!d' ; printf "MiB(used) ") | tr '\n' ' '

printf "\n\n${normal}"


