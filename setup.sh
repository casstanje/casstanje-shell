#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

packages=(
    "wget"
    "git"
    "unzip"
    "sddm"
    "hyprland"
    "aquamarine"
    "hyprpaper"
    "hyprland-qt-support"
    "hyprlang"
    "wofi"
    "hyprgraphics"
    "hyprland-qtutils"
    "hyprshot"
    "hyprpolkitagent"
    "xdg-desktop-portal-hyprland"
    "qt6ct"
    "nwg-look"
    "nwg-displays"
    "network-manager-applet"
    "dunst"
    "pavucontrol"
    "waybar"
    "flatpak"
    "nm-connection-editor"
    "fastfetch"
    "blueman"
    "bluez"
    "nemo"
    "firefox"
    "github-cli"
    "gtk4"
    "ttf-jetbrains-mono"
    "ttf-jetbrains-mono-nerd"
    "partitionmanager"
    "plasma-systemmonitor"
    "power-profiles-daemon"
    "qt6-svg"
    "qt6-declarative"
    "qt5-quickcontrols"
)

_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

# Thanks, https://stackoverflow.com/a/27587157
_isInstalled() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

_install() {
    package="$1";

    # If the package IS installed:
    if [[ $(_isInstalled "${package}") == 0 ]]; then
        echo "\"${package}\" is already installed. Continuing...";
        return;
    fi;

    # If the package is NOT installed:
    if [[ $(_isInstalled "${package}") == 1 ]]; then
        yay -S --noconfirm "${package}" > /dev/null;
        echo "Installed \"${package}\"! Continuing..."
    fi;
}

_installYay() {
    if [[ $(_isInstalled "base_devel") != 0 ]]; then
        pacman -S --noconfirm base_devel > /dev/null
    fi

    if [[ $(_isInstalled "git") != 0 ]]; then
        pacman -S --noconfirm git > /dev/null
    fi


    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    cd "$HOME"/Downloads || exit

    if [ -d "casstanje-yay-bin" ]; then
        rm -rf casstanje-yay-bin
    fi

    mkdir casstanje-yay-bin

    git clone https://aur.archlinux.org/yay.git casstanje-yay-bin
    cd casstanje-yay-bin || exit
    makepkg -si

    rm -rf casstanje-yay-bin

    cd "$temp_path" || exit
    echo "Installed \"yay\"! Continuing..."
}

echo "######################################"
echo "### CASSTANJE'S DOTFILES INSTALLER ###"
echo "######################################"
echo ""
echo "Start installation? [Y/n]"
read -s -n 1 startInstaller
if [ "$startInstaller" = "n" ] || [ "$startInstaller" = "N" ]; then
    echo "Installation cancelled"
else
    if [[ $(_checkCommandExists "yay") == 0 ]]; then
        echo "Yay is installed! YAY!"
    else
        echo "Yay is not installed. Installing now..."
        _installYay
    fi

    echo
    echo "-----"

    for package in "${packages[@]}"
    do
        _install "$package"
        echo ""
    done

    sudo systemctl enable sddm.service > /dev/null
    sudo systemctl enable bluetooth.service > /dev/null

    echo
    echo "-----"
    echo "Install graphics driver? (0 = none (default), 1 = NVidia, 2 = AMD) "
    read -s -n 1 gpuDriver
    if [ "$gpuDriver" = "1" ]; then
        echo "Which driver? (0 = cancel, 1 = proprietary [card < RTX 50xx], 2 = open-source modules [blackwell, card >= RTX 50xx], 3 = nouveau [card < GTX 16xx], 4 = nouveau [GTX 16xx and RTX])"
        echo "More info: https://wiki.hypr.land/Nvidia/, https://wiki.archlinux.org/title/Nouveau, https://wiki.archlinux.org/title/Nvidia"
        read -s -n 1 nvidiaDriver
        if [ "$nvidiaDriver" = "1" ]; then
            _install "nvidia-dkms"
        elif [ "$nvidiaDriver" = "2" ]; then 
            _install "nvidia-open-dkms"
        elif [ "$nvidiaDriver" = "3" ] || [ "$nvidiaDriver" = "4" ]; then
            _install "mesa"
            _install "lib32-mesa"
            if [ "$nvidiaDriver" = "4" ]; then
                _install "vulkan-nouveau"
            fi
        fi

        if [ "$nvidiaDriver" == "1" ] || [ "$nvidiaDriver" == "2" ] || [ "$nvidiaDriver" == "3" ] || [ "$nvidiaDriver" == "4" ] ; then
            _install "nvidia-utils" 
            _install "egl-wayland"
            _install "lib32-nvidia-utils"
            _install "nvidia-prime"
        fi

        echo "Also, there's some extra steps that you might need to take to get it working correctly. Look here: https://wiki.hypr.land/Nvidia/"
    elif [ "$gpuDriver" = "2" ]; then
        _install "mesa"
        _install "multilib"
        _install "lib32-mesa"
    fi

    echo
    echo "-----"
    echo "Install .bashrc? [Y/n]"
    echo "This will move your current .bashrc to $HOME/.config/bashrc/. You can move it to $HOME/.config/bashrc/custom if you want it sourced in the new .bashrc"
    echo "Any extra stuff can also be added to $HOME/.config/bashrc/custom/ in files"
    read -s -n 1 installBashrc

    if [ "$installBashrc" = "y" ] || [ "$installBashrc" = "Y" ] || [ "$installBashrc" == "" ]; then
        if [[ -n "$BASH_VERSION" ]]; then
            mkdir -p $HOME/.config/bashrc/custom/
            if [ -f "$HOME/.bashrc" ]; then
                mv -f $HOME/.bashrc $HOME/.config/bashrc/old-bashrc
            fi
            echo "##############" | sudo tee -a $HOME/.bashrc > /dev/null
            echo "### BASHRC ###" | sudo tee -a $HOME/.bashrc > /dev/null
            echo "##############" | sudo tee -a $HOME/.bashrc > /dev/null
            echo "" | sudo tee -a $HOME/.bashrc > /dev/null
            echo "# DO NOT DELETE" | sudo tee -a $HOME/.bashrc > /dev/null
            echo "# Custom stuff can be added in $HOME/.config/bashrc/custom/ in files you create yourself" | sudo tee -a $HOME/.bashrc > /dev/null
            echo "" | sudo tee -a $HOME/.bashrc > /dev/null
            echo 'if [ "$(ls -A $HOME/.config/bashrc/custom/)" ]; then' | sudo tee -a $HOME/.bashrc > /dev/null
            echo "  for f in $HOME/.config/bashrc/custom/*" | sudo tee -a $HOME/.bashrc > /dev/null
            echo "  do" | sudo tee -a $HOME/.bashrc > /dev/null
            echo '    source "$f"' | sudo tee -a $HOME/.bashrc > /dev/null
            echo "  done" | sudo tee -a $HOME/.bashrc > /dev/null
            echo "fi" | sudo tee -a $HOME/.bashrc > /dev/null
            echo ".bashrc installed!"
        else
            echo "You're not using bash. Cancelling..."
        fi
    fi



    echo 
    echo "-----"
    echo "Install dotfiles and themes? [Y/n]"
    echo "WARNING: THIS WILL REPLACE YOUR CURRENTLY EXISTING DOTFILES FOR THE PROGRAMS IN THIS REPO"
    read -s -n 1 installDotfiles

    if [ "$installDotfiles" = "y" ] || [ "$installDotfiles" = "Y" ] || [ "$installDotfiles" == "" ]; then
        cd "$SCRIPT_DIR" || exit
        
        echo
        echo "Installing python3"
        if [[ $(_checkCommandExists "python3") == 0 ]]; then
            echo "python3 is already insssssstalled."
        else
            _install "python3"
        fi

        echo
        echo "Installing catppuccin GTK theme (https://github.com/catppuccin/gtk/)"
        if python3 catppuccin-gtk-install.py mocha green > /dev/null ; then
            echo "Catppuccin GTK theme installed successfully. Continuing..."
        else
            echo "Couldn't install theme. Continuing..."
        fi

        echo
        echo "Installing SDDM theme"
        cd "$HOME"/Downloads || exit
        wget -q https://github.com/catppuccin/sddm/releases/latest/download/catppuccin-mocha-green-sddm.zip > /dev/null
        sudo mkdir -p /usr/share/sddm/themes/catppuccin-mocha-green
        sudo unzip -o -q catppuccin-mocha-green-sddm.zip -d /usr/share/sddm/themes/catppuccin-mocha-green
        sudo rm -f /etc/sddm.conf
        echo "[Theme]" | sudo tee -a /etc/sddm.conf > /dev/null
        echo "Current=catppuccin-mocha-green" | sudo tee -a /etc/sddm.conf > /dev/null

        cd "$SCRIPT_DIR" || exit

        echo
        echo "Copying dotfiles..."
        cp -r dotfiles/.config/. "$HOME"/.config/

        echo
        echo "Preferred keyboard layout (country code, e.g. 'gb' for great britain, 'de' for german, 'us' for united states)"
        chosenKeyboardLayout=1
        countryCodeRegex='\b(ad|ae|af|ag|ai|al|am|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bl|bm|bn|bo|bq|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cw|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mf|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|ss|st|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tr|tt|tv|tw|tz|ua|ug|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|za|zm|zw)\b'
        while [ $chosenKeyboardLayout == 1 ] 
        do
            read -r keyboardLayout
            if [[ $keyboardLayout =~ $countryCodeRegex ]]; then
                sed -i -e "s/kb_layout = /kb_layout = $keyboardLayout/g" $HOME/.config/hypr/hyprinput.conf
                chosenKeyboardLayout=0
            else
                echo "Country code not valid. Try again."
            fi
        done
    fi

    echo
    echo "-----"
    echo "Installation done!"
    echo "Would you like to reboot now? [N/y]"
    read -s -n 1 shouldReboot
    if [ "$shouldReboot" = "y" ]; then
        reboot
    elif [ "$shouldReboot" = "Y" ]; then 
        reboot
    fi
fi
