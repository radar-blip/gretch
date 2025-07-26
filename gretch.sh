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


#OS Name
os=$(cat /etc/os-release | grep -m 1 'NAME' | cut -d '"' -f 2)
if [ -n "$os" ]; then
    printf "OS:%-9s%s\n" "" "$os"
fi


#OS Version
ver=$(cat /etc/os-release | grep -m 1 'VERSION' | cut -d '"' -f 2)
if [ -n "$ver" ]; then
    printf "Version:%-4s%s\n" "" "$ver"
fi 


#DE (desktop environment)
version=(cinnamon mate xfce debian)
set -- $version
den="$DESKTOP_SESSION"
if [[ "$den" == $1 ]]; then
    printf "DE:%-9s%s\n" "" "$den" | tr 'c' 'C'
elif [[ "$den" == $2 ]]; then
    printf "DE:%-9s%s\n" "" "$den" | tr 'm' 'M'
elif [[ "$den" == $3 ]]; then
    printf "DE:%-9s%s\n" "" "$den" | tr 'x' 'X'
elif [[ "$den" == $4 ]]; then
    printf "DE:%-9s%s\n" "" "$den" | tr 'd' 'D'
else
    printf "DE:%-9s$den\n"
fi


#Kernel
kern=$(uname -r)
if [ -n $kern ]; then
    printf "Kernel:%-5s%s\n" "" "$kern"
fi


#Uptime
utime=$(uptime -p | cut -c 4-)
if [[ -n $utime ]]; then
    printf "Uptime:%-5s%s\n" "" "$utime"
fi


#Shell
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


#Theme
theme=$(gtk-query-settings theme | grep 'gtk-theme-name' | cut -d ":" -f 2 | sed 's/$/[GTK2\/3] /' | tr '"' ' ')
if [ -n "$theme" ]; then
    printf "Theme:%-4s%s\n" "" "$theme"
fi


#Icons
icons=$(gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -d ":" -f 2 | sed 's/$/[GTK2\/3] /' | tr '"' ' ')
if [ -n "$icons" ]; then
    printf "Icons:%-4s%s\n" "" "$icons"
fi


#Desktop theme (no output if not found)
dtheme=$(gsettings get org.cinnamon.theme name 2>/dev/null | tr -d "''")
if [ -n "$dtheme" ]; then
    printf "Desktop:%-4s%s\n" "" "$dtheme"
fi


#Resolution
res=$(xdpyinfo | awk '/dimensions/ {print $2}')
if [ -n $"res" ]; then
    printf "Resolution:%-1s%s\n" "" "$res"
fi


#Packages
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
gpu=$(lspci | grep -E 'VGA|3D' | cut -d ':' -f 3 | sed 's/^ //' | awk '{$1=$1}1')
if [ -n "$gpu" ]; then
    printf "GPU:%-8s%s\n" "" "$gpu"
fi


#VRAM
vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null)
if [ -n "$vram" ]; then
    printf "VRAM:%-7s%s MiB\n" "" "$vram"
fi


#Memory (in mebibytes)
(printf "Memory:%-5s" ; free -m | grep -oP '\d+' | sed '2!d' | sed 's/$/MiB \//'
                        free -m | grep -oP '\d+' | sed '1!d' | sed 's/$/MiB /') | tr '\n' ' '

printf "${norm}\n\n"

