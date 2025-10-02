#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if -f "$SCRIPT_DIR/custom_packages" ; then
    source "$SCRIPT_DIR/custom_packages"    
fi
PACKAGE_LIST=(
    "breeze"
    "breeze-gtk"
    "jq"
    "pipewire"
    "lib32-pipewire"
    "pavucontrol-qt"
    "imagemagick"
    "qt6ct"
    "kvantum"
    "kvantum-theme-catppuccin-git"
    "hyprland"
    "hyprpaper"
    "hyprpicker"
    "bluez"
    "bluez-utils"
    "blueman"
    "networkmanager"
    "nm-connection-editor"
    "network-manager-applet"
    "xdg-desktop-portal-hyprland"
    "hyprpolkitagent"
    "hyprland-qt-support"
    "hyprcursor"
    "fastfetch"
    "hyprland-qtutils"
    "nwg-displays"
    "quickshell"
    "rofi-wayland"
    "zen-browser"
    "kitty"
    "nemo"
    "code"
    "catppuccin-gtk-theme-mocha"
    "ttf-jetbrains-mono"
    "papirus-icon-theme"
    "papirus-folders-catppccin-git"
    "ttf-jetbrains-mono-nerd"
)
packageExists() {
    local package=$1
    if [ -z "$(yay -Q | grep $package)" ]; then
        echo false
    else
        echo true
    fi
}

commandExists() {
    local command=$1
    if [ -x "$(command -v $command)" ]; then 
        echo true
    else 
        echo false 
    fi
}

installPackage() {
    local package=$1
    local quiet=false
    local nl=$'\n'
    if ! [ -z "$2" ] ; then quiet=true; fi
    if ! $quiet ; then printf "${nl}Starting install of $package $nl" >&2 ; fi
    if ! $(packageExists "$package")
    then
        yay -S --quiet --noconfirm $package > /dev/null
        if ! $quiet ; then
            printf "Installed $package $nl" >&2
        fi
    else
        if ! $quiet ; then printf "$package already installed $nl" >&2 ; fi
    fi
}

yaeNae() {
    local message=$1
    local default=$2 # either n or y
    local prompt=""
    local validInput=false
    if [ "$default" == "y" ]; then prompt="$message [Y/n]"; else prompt="$message [N/y]"; fi
    while ! $validInput; do
        read -p "$prompt: " input
        input="$(echo "$input" | tr '[:upper:]' '[:lower:]')"
        if [ -z "$input" ]; then
            input="$default"
        fi
        if [ "$input" != "y" ] && [ "$input" != "n" ]; then
            printf 'Invalid input. Try again\n' >&2
            validInput=false
        else
            validInput=true
        fi
    done
    if [ "$default" == "y" ]; then 
        if [ "$input" == "n" ]; then
            echo false
        else
            echo true
        fi
    else
        if [ "$input" == "y" ]; then
            echo true
        else
            echo false
        fi
    fi
}

main() {
    installPackage "figlet" "true"

    figlet -f slant "casstanje shell installer"

    if ! $(yaeNae "Start installer? You will be prompted to backup your current dotfiles later, don't worry" "y")
    then
        exit 0
    fi

    echo "checking for yay install"
    if $(commandExists "yay") 
    then
        echo "yay is already installed"
    else 
        echo "yay not found. installing yay..."
        pacman -S --noconfirm --needed git base-devel > /dev/null
        cd ~/Downloads/
        git clone https://aur.archlinux.org/yay.git > /dev/null
        cd yay
        
        makepkg -si > /dev/null
        cd ..
        rm -rf yay
        cd $SCRIPT_DIR
        echo "yay install complete"
    fi

    printf '\n-\nInstalling dependencies...\n'
    for package in "${PACKAGE_LIST[@]}"
    do
        installPackage "$package"
    done

    if [[ -v custom_packages ]]; then
        echo
        prinf '\n-\nInstalling custom packages...\n'
        for package in "${custom_packages[@]}"
            installPackage "$package"
        done
    fi

    echo
    if $(yaeNae "Install power-profiles-daemon and brightnessctl? (recomended for laptops)" "n")
    then
        installPackage "power-profiles-daemon"
        installPackage "brightnessctl"
        sudo systemctl enable --now power-profiles-daemon
    fi

    echo
    if $(yaeNae "Backup current dotfiles?" "y")
    then
        BD="$HOME/homeBackup"
        if [ ! -d "$BD" ]; then mkdir "$BD" ; fi
        if [ -f "$HOME/.bashrc" ]; then cp -f $HOME/.bashrc "$BD/" ; fi
        if [ -f "$HOME/.dircolors" ]; then cp -f $HOME/.dircolors "$BD/" ; fi
        if [ -d "$HOME/.config" ]; then cp -rf $HOME/.config "$BD/" ; fi
        echo "Files have been backed up at $BD"
    fi

    printf '\n-\nInstalling config...\n'
    cd $SCRIPT_DIR
    cp -rf dotfiles/. $HOME/

    printf '\n-\nInstalling casstanje shell customizer\n'
    cd $SCRIPT_DIR
    if [ ! -d "$HOME/.local/share/applications/" ]; then mkdir -p $HOME/.local/share/applications/ ; fi
    cp CasstanjeShellCustomizer.desktop $HOME/.local/share/applications/

    printf '\n-\nEnabling services...\n'
    systemctl enable --user --now hyprpolkitagent
    sudo systemctl enable --now bluetooth
    sudo systemctl enable --now NetworkManager

    printf '\n-\nSetting xdg-mime defaults\n'
    xdg-mime default zen.desktop x-scheme-handler/http x-scheme-handler/https
    xdg-mime default nemo.desktop inode/directory

    nl='\n'
    printf "${nl}-${nl}Done!${nl}If you're on a nvidia card, you should uncomment the last few lines in ~/.config/hyprenv.conf before rebooting. Also look at the Nvidia page of both the archwiki (https://wiki.archlinux.org/title/NVIDIA) and the hyprland wiki (https://wiki.hypr.land/0.45.0/Nvidia/) for additional help with installing the correct drivers and setting them up correctly${nl}You should reboot before using the shell${nl}Thank you!"
}

main
