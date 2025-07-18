#!/bin/bash
# gretch 
# system info gathering script

bold=$(tput bold)
norm=$(tput sgr0)
yell=$(tput setaf 3)

clear
printf "${bold}"

whom=$(id -u -n)
where=$(hostname)
printf '%s' "$whom" "@" "$where" 
printf '%s' "$whom" | tr "$whom" '\n-' 
printf '%s' "$where" | tr "$where" '-' | awk '{print $0"--"}'
printf "\n"


#OS name
printf "OS:%-9s" ; cat /etc/os-release | grep -m 1 'NAME' | cut -d '"' -f 2


#OS version
printf "Version:%-4s" ; cat /etc/os-release | grep -m 1 'VERSION' | cut -d '"' -f 2


#DE (desktop environment)
if [ $DESKTOP_SESSION == "cinnamon" ]; then
    printf "DE:%-9s$DESKTOP_SESSION\n" | tr 'c' 'C'
elif [ $DESKTOP_SESSION == "mate" ]; then
    printf "DE:%-9s$DESKTOP_SESSION\n" | tr 'm' 'M'
elif [ $DESKTOP_SESSION == "xfce" ]; then
    printf "DE:%-9s$DESKTOP_SESSION\n" | tr 'x' 'X'
elif [ $DESKTOP_SESSION == "debian" ]; then
    printf "DE:%-9s$DESKTOP_SESSION\n" | tr 'd' 'D'
else
    printf "DE:%-9s$DESKTOP_SESSION\n"
fi


#kernel
printf "Kernel:%-5s" ; uname -r


#uptime
printf "Uptime:%-5s" ; uptime -p | cut -c 4-


#shell
var=bash
if [ $var == "bash" ]; then
    printf "Shell:%-6s" ; basename $(readlink /proc/$$/exe) | tr '\n' ' '
    printf "$BASH_VERSION" | cut -c 1-6 
else
    printf "Shell:%-6s" ; basename $(readlink /proc/$$/exe) 
fi


#WM (window manager)
wman=$(wmctrl -m 2>/dev/null | grep Name | cut -d ":" -f 2 )
if [ -n "$wman" ]; then
    printf "WM:%-8s%s\n" "" "$wman"
else
    printf "WM:%-9s%s\n" "" "wmctrl not installed"
fi


#theme
printf "Theme:%-4s" ; gtk-query-settings theme | grep 'gtk-theme-name' | cut -d ":" -f 2 | sed 's/$/[GTK2\/3] /' | tr '"' ' '


#icons
printf "Icons:%-4s" ; gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -d ":" -f 2 | sed 's/$/[GTK2\/3] /' | tr '"' ' '


#desktop theme (no output if not found)
dtheme=$(gsettings get org.cinnamon.theme name 2>/dev/null | tr -d "''")
if [ -n "$dtheme" ]; then
    printf "Desktop:%-4s%s\n" "" "$dtheme"
fi


#resolution
printf "Resolution:%-1s" ; xdpyinfo | awk '/dimensions/ {print $2}'


#packages
if [ $(flatpak list | wc -l) -eq 0 ]; then
    printf "Packages:%-3s" ; dpkg --get-selections | wc -l | sed 's/$/ (dpkg)/' 
else
    printf "Packages:%-3s" ; dpkg --get-selections | wc -l | sed 's/$/ (dpkg),/' | tr '\n' ' '
                             flatpak list | wc -l | sed 's/$/ (flatpak)/'
fi


#CPU
if [ "AMD A4-6300" ]; then
    printf "CPU:%-8s" ; lscpu | grep 'Model name' | cut -d ":" -f 2 | awk '{$1=$1}1' | sed 's/w.*//' | tr '\n' ' '
                        lscpu | grep 'max' | cut -d ":" -f 2 | awk '{$1=$1}1' | awk '{printf "\b@ " substr($0, 1, length($0)-5)}' | sed 's/$/ MHz\n/' #short
else
    printf "CPU:%-8s" ; lscpu | grep 'Model name' | cut -d ":" -f 2 | awk '{$1=$1}1' | tr '\n' ' '
                        lscpu | grep 'max' | cut -d ":" -f 2 | awk '{$1=$1}1' | awk '{printf "@ " substr($0, 1, length($0)-5)}' | sed 's/$/ MHz\n/' #long output
fi


#GPU
printf "GPU:%-8s" 
lspci | grep -E 'VGA|3D' | cut -d ':' -f 3 | sed 's/^ //' | awk '{$1=$1}1'


#VRAM
vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null)
if [ -n "$vram" ]; then
    printf "VRAM:%-7s%s MiB\n" "" "$vram"
fi


#memory (in mebibytes)
(printf "Memory:%-5s" ; free -m | grep -oP '\d+' | sed '2!d' | sed 's/$/MiB \//'
                        free -m | grep -oP '\d+' | sed '1!d' | sed 's/$/MiB /') | tr '\n' ' '


printf "${norm}\n\n"


