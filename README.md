# Casstanje's Catppuccin Hyprland Shell for Arch
## Introduction
![Alt text](/assets/images/preview_1.png "preview")
The shell uses these packages:
- obviously hyprland
- quickshell for the taskbar
- rofi-wayland for the application launcher
- kitty as the terminal
- networkmanager, network-manager-applet and nm-connection-editor for networking
- bluez and blueman for bluetooth
- plasmasystemmonitor for monitoring
- power-profiles-daemon for power management
- swaync for notfications
- and some others. The full list can be found in setup.sh

Most configs are based on the official catppuccin ones, just edited a little to fit my style more.

## How to install
First of all, clone this repo and cd into it.
```bash
git clone https://github.com/casstanje/arch-hyprland-dotfiles casstanjes-arch-hyprland-dotfiles
cd casstanjes-arch-hyprland-dotfiles
```

Just run setup.sh on an Arch installation. I've only tested it on a clean no desktop Endeavour isntall, but it should work on most Arch distros.

### Additional packages
If you want to install additional packages, you can do so by creating a file with a bash array of package names by the name of custom_packages e.g.
```bash
custom_packages=(
    "github_cli"
    "firefox"
    "code"
)
```
and uncommenting and editing this line in setup.sh:
```bash
# custom_packages_file='<path_to_file>'
```
to reference your file.

Or just, y'know, create the array in the install file itself. Whatever you prefer

After that, just run setup.sh.

## TODO
- Infinite (not really) submenu layers for system tray

### maybes
- Let the user choose which widgets to use in the bar
- Let the user choose between catppuccin flavours, with green as the default
