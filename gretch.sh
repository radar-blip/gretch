#!/usr/bin/env bash
# gretch 
# system info gathering script
# for linux


bold=$(tput bold)
norm=$(tput sgr0)
yell=$(tput setaf 3)


clear
printf "${bold}"
shopt -s nocasematch


# User/Hostname
ghost=$(id -un && hostname)
printf "$ghost" | tr '\n' '@'
printf "\n${ghost//?/-}\n\n"


# OS Name/Version 
osname=$(grep -E '^NAME=|^VERSION=' /etc/os-release | cut -d '"' -f 2 | tr '\n' ' ')
arch=$(uname -m)

# on/off switch to show/hide architecture (ie x86_64)
# on = show / off = hide
arch_switch="on"

case $arch_switch in
    on)
        [[ -n "$osname" ]] && printf "%-11s %s" "OS:" "$osname"
        [[ -n "$arch" ]] && printf "%-11s %s\n" "$arch"
        ;;
    off)
        [[ -n "$osname" ]] && printf "%-11s %s\n" "OS:" "$osname"
        ;;
    *)
        printf "%-11s %s\n" "OS:" "$osname"
        ;;
esac


# DE (desktop environment)
de=$(printf $XDG_CURRENT_DESKTOP)

case "$de" in
    gnome)
        printf "%-11s %s\n" "DE:" "Gnome"
        ;;
    mate)
        printf "%-11s %s\n" "DE:" "Mate"
        ;;
    xfce)
        printf "%-11s %s\n" "DE:" "Xfce"
        ;;
    cinnamon | x-cinnamon)
        printf "%-11s %s\n" "DE:" "Cinnamon"
        ;;
    kde)
        printf "%-11s %s\n" "DE:" "KDE"
        ;;
    lxde)
        printf "%-11s %s\n" "DE:" "LXDE"
        ;;
    *)
        printf "%-11s %s\n" "DE:" "$de"
        ;;
esac


# Kernel
kern=$(uname -r)
[[ -n $kern ]] && printf "%-11s %s\n" "Kernel:" "$kern"


# Uptime
utime=$(uptime -p | cut -c 4-)
[[ -n $utime ]] && printf "%-11s %s\n" "Uptime:" "$utime"

    
# Shell
shell_name=$(basename "$SHELL")
bash_ver=$(basename "$BASH_VERSION" | cut -c 1-6)

case "$shell_name" in
    bash)
        printf "%-11s %s\n" "Shell:" "bash $bash_ver"
        ;;
    sh)
        printf "%-11s %s\n" "Shell:" "sh"
        ;;
    zsh)
        printf "%-11s %s\n" "Shell:" "zsh"
        ;;
    fish)
        printf "%-11s %s\n" "Shell:" "fish"
        ;;
    csh)
        printf "%-11s %s\n" "Shell:" "csh"
        ;;
    ksh)
        printf "%-11s %s\n" "Shell:" "ksh"
        ;;
    dash)
        printf "%-11s %s\n" "Shell:" "dash"
        ;;
    tcsh)
        printf "%-11s %s\n" "Shell:" "tcsh"
        ;;
    *)
        printf "%-11s %s\n" "Shell:" "$shell_name"
        ;;
esac

    
# WM (window manager)
wman=$(wmctrl -m 2>/dev/null | grep 'Name' | cut -d ":" -f 2)
[[ -n "$wman" ]] && \
    printf "%-10s %s\n" "WM:" "$wman" || \
    printf "%-11s %s\n" "WM:" "wmctrl not installed"


# Theme
theme=$(gtk-query-settings theme | grep 'gtk-theme-name' | cut -d ":" -f 2 | tr -d '"')
[[ -n "$theme" ]] && printf "%-10s %s\n" "Theme:" "$theme [GTK2/3]"


# Icons
icons=$(gtk-query-settings theme | grep 'gtk-icon-theme-name' | cut -d ":" -f 2 | tr -d '"')
[[ -n "$icons" ]] && printf "%-10s %s\n" "Icons:" "$icons [GTK2/3]"


# Desktop theme (no output if not found)
dtheme=$(gsettings get org.cinnamon.theme name 2>/dev/null | tr -d "''")
[[ -n "$dtheme" ]] && printf "%-11s %s\n" "Desktop:" "$dtheme"


# Resolution
res=$(xdpyinfo | awk '/dimensions/ {print $2}')
[[ -n $"res" ]] && printf "%-11s %s\n" "Resolution:" "$res"


# Packages
packages=$(dpkg --get-selections | wc -l)
flatpaks=$(flatpak list | wc -l)
[[ $(flatpak list | wc -l) -eq 0 ]] && \
    printf "%-11s %s %s\n" "Packages:" "$packages" "(dpkg)" || \
    printf "%-11s %s %s %s %s\n" "Packages:" "$packages" "(dpkg)," "$flatpaks" "(flatpak)"


# CPU
cpu_def=$(lscpu | awk -F': *' '/Model name/{printf $2}')
cpu_amd=$(lscpu | awk -F': *' '/Model name/{printf $2}' | cut -d ' ' -f 1,2,3)
max_ghz=$(lscpu | awk -F': *' '/CPU max MHz/{printf "@ " ($2/1000) " GHz"}')
case "$cpu_amd" in
    *amd* | *radeon* | *ryzen*)
        printf "%-11s %s %s\n" "CPU:" "$cpu_amd" "$max_ghz"
        ;;
    *intel* | *core*)
        printf "%-11s %s %s\n" "CPU:" "$cpu_def" "$max_ghz"
        ;;
    *)
        printf "%-11s %s %s\n" "CPU:" "$cpu_def" "$max_ghz"
        ;;
esac


# GPU
gpu_def=$(lspci | awk '/VGA|3D|Display/ {print $0}' | cut -d ':' -f 3 | sed 's/^ //')
gpu_amd=$(lspci | awk '/VGA|3D|Display/ {print $0}' | cut -d ':' -f 3 | sed 's/^ //' | tr '/' ' ' | awk -F'[][]' '{print $2,$4}')
case "$gpu_amd" in
    *amd* | *radeon*)
        printf "%-11s %s\n" "GPU:" "$gpu_amd"
        ;;
    *nvidia* | *geforce*)
        printf "%-11s %s\n" "GPU:" "$gpu_def"
        ;;
    *)
        printf "%-11s %s\n" "GPU:" "$gpu_def"
        ;;
esac


# VRAM
vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null)
[[ -n "$vram" ]] && printf "%-11s %s %s\n" "VRAM:" "$vram" "MiB"


# Memory (in mebibytes)
mem_used=$(free -m | awk 'NR==2{print $3}')
mem_total=$(free -m | awk 'NR==2{print $2}')
printf "%-11s %s %s %s" "Memory:" "${mem_used}MiB" "/" "${mem_total}MiB"

printf "${norm}\n\n"

