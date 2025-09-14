#!/usr/bin/env bash
# gretch 
# system info gathering script
# for linux


bold=$(tput bold)
norm=$(tput sgr0)
yell=$(tput setaf 3)


clear
printf "${bold}"


#User/Hostname
ghost=$(id -un && hostname)
printf "$ghost" | tr '\n' '@'
printf "\n${ghost//?/-}\n\n"


#OS Name/Version
osname=$(grep -E '^NAME=|^VERSION=' /etc/os-release | cut -d '"' -f 2 | tr '\n' ' ')
[[ -n "$osname" ]] && printf "%-11s %s\n" "OS:" "$osname"


#DE (desktop environment)
de=${XDG_CURRENT_DESKTOP,,}
[[ -n "$de" ]] && printf "%-11s %s\n" "DE:" "${de^}"


#Kernel
kern=$(uname -r)
[[ -n $kern ]] && printf "%-11s %s\n" "Kernel:" "$kern"


#Uptime
utime=$(uptime -p | cut -c 4-)
[[ -n $utime ]] && printf "%-11s %s\n" "Uptime:" "$utime"

    
#Shell
var1=$(basename "$SHELL") 
var2=$(basename "$BASH_VERSION" | cut -c 1-6)
[[ $var1 == "bash" ]] && \
    printf "%-11s %s %s\n" "Shell:" "$var1" "$var2" || \
    printf "%-11s %s\n" "Shell:" "$var1"

    
#WM (window manager)
wman=$(wmctrl -m 2>/dev/null | grep Name | cut -d ":" -f 2)
[[ -n "$wman" ]] && \
    printf "%-10s %s\n" "WM:" "$wman" || \
    printf "%-11s %s\n" "WM:" "wmctrl not installed"


#Theme
theme=$(gtk-query-settings theme | grep 'gtk-theme-name' | cut -d ":" -f 2 | tr -d '"')
[[ -n "$theme" ]] && printf "%-10s %s\n" "Theme:" "$theme [GTK2/3]"


#Icons
icons=$(gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -d ":" -f 2 | tr -d '"')
[[ -n "$icons" ]] && printf "%-10s %s\n" "Icons:" "$icons [GTK2/3]"


#Desktop theme (no output if not found)
dtheme=$(gsettings get org.cinnamon.theme name 2>/dev/null | tr -d "''")
[[ -n "$dtheme" ]] && printf "%-11s %s\n" "Desktop:" "$dtheme"


#Resolution
res=$(xdpyinfo | awk '/dimensions/ {print $2}')
[[ -n $"res" ]] && printf "%-11s %s\n" "Resolution:" "$res"


#Packages
packages=$(dpkg --get-selections | wc -l)
flatpaks=$(flatpak list | wc -l)
[[ $(flatpak list | wc -l) -eq 0 ]] && \
    printf "%-11s %s %s\n" "Packages:" "$packages" "(dpkg)" || \
    printf "%-11s %s %s %s %s\n" "Packages:" "$packages" "(dpkg)," "$flatpaks" "(flatpak)"


#CPU
amd_model_yes=$(lscpu | grep 'Model name' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d ' ' -f 1,2,3 | tr '\n' ' ')
amd_speed_yes=$(lscpu | grep 'CPU max MHz' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d '.' -f 1)
mhz_to_ghz=$(echo "scale=3; $amd_speed_yes / 1000" | bc)
amd_model_no=$(lscpu | grep 'Model name' | cut -d ":" -f 2 | awk '{$1=$1}1' | tr '\n' ' ')
amd_speed_no=$(lscpu | grep 'CPU max MHz' | cut -d ":" -f 2 | awk '{$1=$1}1' | cut -d '.' -f 1)
mhz_to_ghz=$(echo "scale=3; $amd_speed_no / 1000" | bc)
[[ "AMD" ]] && \
    printf "%-11s %s%s %s\n" "CPU:" "$amd_model_yes" "@" "$mhz_to_ghz GHz" || \
    printf "%-11s %s%s %s\n" "CPU:" "$amd_model_no" "@" "$mhz_to_ghz GHz"


#GPU
gpu=$(lspci | grep -E 'VGA|3D' | cut -d ':' -f 3 | sed 's/^ //' | awk '{$1=$1}1')
[[ -n "$gpu" ]] && printf "%-11s %s\n" "GPU:" "$gpu"


#VRAM
vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null)
[[ -n "$vram" ]] && printf "%-11s %s %s\n" "VRAM:" "$vram" "MiB"


#Memory (in mebibytes)
mem_used=$(free -m | awk 'NR==2{print $3}')
mem_total=$(free -m | awk 'NR==2{print $2}')
printf "%-11s %s %s %s" "Memory:" "${mem_used}MiB" "/" "${mem_total}MiB"

printf "${norm}\n\n"

