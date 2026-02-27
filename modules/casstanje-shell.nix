{ config, pkgs, system, inputs, quickshell, lib, ctpFlavor, ctpAccent, ... }:
let
  system = pkgs.system;
  quickshell = inputs.quickshell.packages."${system}".default.withModules [
    pkgs.kdePackages.qt5compat
  ];
  userConfigPath = "${config.home.homeDirectory}/.config/casstanje-shell/clean-user-config.json";
  userConfig = if builtins.pathExists "${userConfigPath}" 
    then builtins.fromJSON (builtins.readFile "${userConfigPath}")
    else {};
  ctpFlavor = "mocha";
  ctpAccent = if builtins.hasAttr "catppuccinaccent" userConfig 
    then userConfig.catppuccinaccent 
    else "mauve";
  optionIfNull = attr: default: if builtins.hasAttr attr userConfig then builtins.toString (userConfig.${attr}) else default;
in
{
  imports = [ 
    (
      import ./gtk-qt.nix (
        { inherit config pkgs ctpFlavor ctpAccent;}
      )
    )
    (
      import ./terminal-shell.nix (
        { inherit config pkgs ctpFlavor ctpAccent;}
      )
    ) 
    (
      import ./quickshell.nix (
        { inherit config pkgs ctpFlavor ctpAccent optionIfNull;}
      )
    ) 
    (
      import ./hyprland.nix (
        { inherit config pkgs lib ctpFlavor ctpAccent optionIfNull;}
      )
    ) 
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Shell 
    jq
    figlet
    oh-my-zsh
    fastfetch

    # Code packages
    python3
    imagemagick
    bluez-tools
    libnotify
    bluez

    # Tray
    networkmanagerapplet

    # Theming
    kdePackages.qtstyleplugin-kvantum
    qt6Packages.qt6ct
    nerd-fonts.jetbrains-mono
    catppuccin-kvantum
    papirus-folders
    gtk3
    gtk4

    # Applications
    inputs.zen-browser.packages."${system}".default
    vscode
    
    # GUIs
    lxqt.pavucontrol-qt
    nwg-displays
    nemo-with-extensions

    # Hyprland
    hyprland
    hyprpaper
    hyprshot
    hyprpicker
    hyprcursor
    hyprpolkitagent

    # Clipboard
    wl-clipboard
    wl-clip-persist
    cliphist

    # Other
    quickshell
    home-manager
    swaybg


    # Shell Customizer
    (makeDesktopItem {
      name = "Casstanje Shell Customizer";
      desktopName = "Casstanje Shell Customizer";
      exec = "bash -c \"quickshell -p ${config.home.homeDirectory}/.config/quickshell/default/CustomizationWindow.qml\"";
      terminal = false;
    })
  ];

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [
      rofi-emoji
      rofi-calc
    ];
  };

  catppuccin = {
    enable = false;
    flavor = ctpFlavor;
    accent = ctpAccent;

    cursors = {
      enable = true;
      accent = "dark";
    };
  };

  xdg.configFile = {
    "casstanje-shell" = {
      source = ./../dotfiles/.config/casstanje-shell;
      recursive = true;
    };
    "rofi" = {
      source = ./../dotfiles/.config/rofi;
      recursive = true;
    };
    "rofi/userconfig.rasi" = {
      text = ''
        @import "catppuccin-mocha"
        * {
          ctpAccent: @${ctpAccent};
          borderRadius: ${(optionIfNull "border_radius" "4")}px;
          borderWidth: ${(optionIfNull "border_width" "2")}px;
        }
      '';
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
