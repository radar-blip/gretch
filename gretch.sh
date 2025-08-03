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
if [[ -n "$os" ]]; then
    printf "OS:%-9s%s\n" "" "$os"
fi


#OS Version
ver=$(cat /etc/os-release | grep -m 1 'VERSION' | cut -d '"' -f 2)
if [[ -n "$ver" ]]; then
    printf "Version:%-4s%s\n" "" "$ver"
fi 


#DE (desktop environment)
printf "DE:%-9s%s\n" "" "${DESKTOP_SESSION^}"


#Kernel
kern=$(uname -r)
if [[ -n $kern ]]; then
    printf "Kernel:%-5s%s\n" "" "$kern"
fi


#Uptime
utime=$(uptime -p | cut -c 4-)
if [[ -n $utime ]]; then
    printf "Uptime:%-5s%s\n" "" "$utime"
fi


#Shell
var=bash
if [[ $var == "bash" ]]; then
    printf "Shell:%-6s" ; basename $(readlink /proc/$$/exe) | tr '\n' ' '
    printf "$BASH_VERSION" | cut -c 1-6 
else
    printf "Shell:%-6s" ; basename $(readlink /proc/$$/exe) 
fi


#WM (window manager)
wman=$(wmctrl -m 2>/dev/null | grep Name | cut -d ":" -f 2 )
if [[ -n "$wman" ]]; then
    printf "WM:%-8s%s\n" "" "$wman"
else
    printf "WM:%-9s%s\n" "" "wmctrl not installed"
fi


#Theme
theme=$(gtk-query-settings theme | grep 'gtk-theme-name' | cut -d ":" -f 2 | tr '"' ' ')
if [[ -n "$theme" ]]; then
    printf "Theme:%-4s%s[GTK2/3]\n" "" "$theme"
fi


#Icons
icons=$(gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -d ":" -f 2 | tr '"' ' ')
if [[ -n "$icons" ]]; then
    printf "Icons:%-4s%s[GTK2/3]\n" "" "$icons"
fi


#Desktop theme (no output if not found)
dtheme=$(gsettings get org.cinnamon.theme name 2>/dev/null | tr -d "''")
if [[ -n "$dtheme" ]]; then
    printf "Desktop:%-4s%s\n" "" "$dtheme"
fi


#Resolution
res=$(xdpyinfo | awk '/dimensions/ {print $2}')
if [[ -n $"res" ]]; then
    printf "Resolution:%-1s%s\n" "" "$res"
fi


#Packages
if [[ $(flatpak list | wc -l) -eq 0 ]]; then
    printf "Packages:%-3s" ; dpkg --get-selections | wc -l | sed 's/$/ (dpkg)/' 
else
    printf "Packages:%-3s" ; dpkg --get-selections | wc -l | sed 's/$/ (dpkg),/' | tr '\n' ' '
                             flatpak list | wc -l | sed 's/$/ (flatpak)/'
fi


#CPU
cpuamd=$(lscpu | grep 'Model name' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d ' ' -f 1,2,3 | tr '\n' ' '; printf "@ "
         lscpu | grep 'CPU max MHz' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d '.' -f 1)
cpu=$(lscpu | grep 'Model name' | cut -d ":" -f 2 | awk '{$1=$1}1' | tr '\n' ' '; printf "@ "
      lscpu | grep 'CPU max MHz' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d '.' -f 1)
if [[ "AMD" ]]; then
    printf "CPU:%-8s%s MHz\n" "" "$cpuamd"  
else
    printf "CPU:%-8s%s MHz\n" "" "$cpu"  
fi


#GPU
gpu=$(lspci | grep -E 'VGA|3D' | cut -d ':' -f 3 | sed 's/^ //' | awk '{$1=$1}1')
if [[ -n "$gpu" ]]; then
    printf "GPU:%-8s%s\n" "" "$gpu"
fi


#VRAM
vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null)
if [[ -n "$vram" ]]; then
    printf "VRAM:%-7s%s MiB\n" "" "$vram"
fi


#Memory (in mebibytes)
mem=$(free -m | grep -oP '\d+' | sed '2!d' | sed 's/$/MiB \//' | tr '\n' ' '
      free -m | grep -oP '\d+' | sed '1!d' | sed 's/$/MiB /')
if [[ "$mem" ]]; then
    printf "Memory:%-5s%s\n" "" "$mem" 
fi

printf "${norm}\n\n"

