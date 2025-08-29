#!/bin/bash
# gretch 
# system info gathering script


bold=$(tput bold)
norm=$(tput sgr0)
yell=$(tput setaf 3)


clear
printf "${bold}"


#User/Hostname
ghost=$(id -un && hostname)
printf "$ghost" | tr '\n' '@'
printf "\n${ghost//?/-}\n\n"


#OS Name
os=$(grep '^NAME=' /etc/os-release | cut -d '"' -f 2)
if [[ -n "$os" ]]; then
    printf "%-11s %s\n" "OS:" "$os"
fi


#OS Version
ver=$(grep '^VERSION=' /etc/os-release | cut -d '"' -f 2)
if [[ -n "$ver" ]]; then
    printf "%-11s %s\n" "Version:" "$ver"
fi 


#DE (desktop environment)
de=${XDG_CURRENT_DESKTOP,,}
if [[ -n "$de" ]]; then
    printf "%-11s %s\n" "DE:" "${de^}"
fi


#Kernel
kern=$(uname -r)
if [[ -n $kern ]]; then
    printf "%-11s %s\n" "Kernel:" "$kern"
fi


#Uptime
utime=$(uptime -p | cut -c 4-)
if [[ -n $utime ]]; then
    printf "%-11s %s\n" "Uptime:" "$utime"
fi


#Shell
var1=$(basename "$SHELL") 
if [[ $var1 == "bash" ]]; then
    var2=$(echo "$BASH_VERSION" | cut -c 1-6)
    printf "%-11s %s %s\n" "Shell:" "$var1" "$var2" 
else
    printf "%-11s %s\n" "Shell:" "$var1"
fi


#WM (window manager)
wman=$(wmctrl -m 2>/dev/null | grep Name | cut -d ":" -f 2)
if [[ -n "$wman" ]]; then
    printf "%-10s %s\n" "WM:" "$wman"
else
    printf "%-11s %s\n" "WM:" "wmctrl not installed"
fi


#Theme
theme=$(gtk-query-settings theme | grep 'gtk-theme-name' | cut -d ":" -f 2 | tr -d '"')
if [[ -n "$theme" ]]; then
    printf "%-10s %s %s\n" "Theme:" "$theme" "[GTK2/3]"
fi


#Icons
icons=$(gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -d ":" -f 2 | tr -d '"')
if [[ -n "$icons" ]]; then
    printf "%-10s %s %s\n" "Icons:" "$icons" "[GTK2/3]"
fi


#Desktop theme (no output if not found)
dtheme=$(gsettings get org.cinnamon.theme name 2>/dev/null | tr -d "''")
if [[ -n "$dtheme" ]]; then
    printf "%-11s %s\n" "Desktop:" "$dtheme"
fi


#Resolution
res=$(xdpyinfo | awk '/dimensions/ {print $2}')
if [[ -n $"res" ]]; then
    printf "%-11s %s\n" "Resolution:" "$res"
fi


#Packages
packages=$(dpkg --get-selections | wc -l)
flatpaks=$(flatpak list | wc -l)
if [[ $(flatpak list | wc -l) -eq 0 ]]; then
    printf "%-11s %s %s\n" "Packages:" "$packages" "(dpkg)"  
else
    printf "%-11s %s %s %s %s\n" "Packages:" "$packages" "(dpkg)," "$flatpaks" "(flatpak)"  
fi


#CPU
amd_model_yes=$(lscpu | grep 'Model name' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d ' ' -f 1,2,3 | tr '\n' ' ')
amd_speed_yes=$(lscpu | grep 'CPU max MHz' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d '.' -f 1)
mhz_to_ghz=$(echo "scale=3; $amd_speed_yes / 1000" | bc)
amd_model_no=$(lscpu | grep 'Model name' | cut -d ":" -f 2 | awk '{$1=$1}1' | tr '\n' ' ')
amd_speed_no=$(lscpu | grep 'CPU max MHz' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d '.' -f 1)
mhz_to_ghz=$(echo "scale=3; $amd_speed_no / 1000" | bc)
if [[ "AMD" ]]; then
    printf "%-11s %s%s %s %s\n" "CPU:" "$amd_model_yes" "@" "$mhz_to_ghz" "GHz" 
else
    printf "%-11s %s%s %s %s\n" "CPU:" "$amd_model_no" "@" "$mhz_to_ghz" "GHz" 
fi


#GPU
gpu=$(lspci | grep -E 'VGA|3D' | cut -d ':' -f 3 | sed 's/^ //' | awk '{$1=$1}1')
if [[ -n "$gpu" ]]; then
    printf "%-11s %s\n" "GPU:" "$gpu"
fi


#VRAM
vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null)
if [[ -n "$vram" ]]; then
    printf "%-11s %s %s\n" "VRAM:" "$vram" "MiB"
fi


#Memory (in mebibytes)
memused=$(free -m | grep -oP '\d+' | sed '2!d')
memtotal=$(free -m | grep -oP '\d+' | sed '1!d')
if [[ "$memused" ]] && [[ "$memtotal" ]]; then
    printf "%-11s %s%s %s %s%s" "Memory:" "$memused" "MiB" "/" "$memtotal" "MiB"
fi

printf "${norm}\n\n"

