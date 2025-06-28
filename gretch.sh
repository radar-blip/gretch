#/bin/bash
# gretch 
# system info gathering script

bold=$(tput bold)
normal=$(tput sgr0)

clear
printf "${bold}"

whom=$(id -u -n)
where=$(hostname)
printf '%s' "$whom" "@" "$where" 
printf '%s' "$whom" | tr "$whom" '\n-' 
printf '%s' "$where" | tr "$where" '-' | awk '{print $0"--"}'
printf "\n"


#OS name/version
printf "OS:%-9s" ; cat /etc/lsb-release | grep 'DISTRIB_DESCRIPTION' | cut -f2 -d '"'

#desktop environment
printf "DE:%-9s$XDG_CURRENT_DESKTOP\n" | tr -d 'X-'

#kernel
printf "Kernel:%-5s" ; uname -r

#uptime
printf "Uptime:%-5s" ; uptime -p | cut -c 4-

#shell/version
printf "Shell:%-6s" ; ps -o fname --no-headers $$ | tr '\n' ' '
printf "$BASH_VERSION" | cut -c 1-6 | tr '\n' ' ' ; printf "\n"


#WM (window manager)
printf "WM:%-8s" ; wmctrl -m | grep Name | cut -d ":" -f2

#theme
printf "Theme:%-4s" ; gtk-query-settings theme | grep 'gtk-theme-name' | cut -d ":" -f2 | tr '\n"' ' ' ; printf "\b[GTK2/3]\n" 

#icons 
printf "Icons:%-4s" ; gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -d ":" -f2 | tr '\n"' ' ' ; printf "\b[GTK2/3]\n"

#desktop theme
printf "Desktop:%-4s" ; gsettings get org.cinnamon.theme name | tr -d "''"


#resolution
printf "Resolution:%-1s" ; xdpyinfo | awk '/dimensions/ {print $2}'

#packages
if [ "flatpak list | wc -l < 1" ]; then
    printf "Packages:%-3s" ; dpkg --get-selections | wc -l | tr '\n' ' ' ; printf "(dpkg)" ; printf "\n"
else
    printf "Packages:%-3s" ; dpkg --get-selections | wc -l ; printf "(dpkg), "
                             flatpak list | wc -l ; printf "(flatpak)" | tr '\n' ' ' ; printf "\n"
fi


#CPU 
printf "CPU:%-8s" ; lscpu | grep 'Model name' | cut -d ":" -f2 | awk '{$1=$1}1' | tr '\n' ' '
                    #max speed - (if double output, comment out these lines)
                    lscpu | grep 'max' | cut -d ":" -f2 | awk '{$1=$1}1' | awk '{printf "@ " substr($0, 1, length($0)-5)}' ; printf " Mhz" | tr '\n' ' ' ; printf "\n"

#GPU 
printf "GPU:%-7s" ; lspci | grep 'VGA' | cut -d ":" -f3 | tr -d "[]"


#memory (in mebibytes)
(printf "Memory:%-5s" ; free -m | grep -oP '\d+' | sed '1!d' ; printf "MiB(total), " 
                        free -m | grep -oP '\d+' | sed '2!d' ; printf "MiB(used) ") | tr '\n' ' '

printf "${normal}\n\n"


