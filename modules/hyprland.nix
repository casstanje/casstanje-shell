{ config, pkgs, lib, ctpFlavor, ctpAccent, optionIfNull, ... }:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.systemd.enable = false; 

  xdg.configFile = {
    "hypr" = {
      source = ./../dotfiles/.config/hypr;
      recursive = true;
    };
    "hypr/userconfig.conf" = {
      text = lib.concatStrings ["$accent = $" ctpAccent] + ''

        general:gaps_in = ${(optionIfNull "window_gap" "4")}
        general:gaps_out = ${(optionIfNull "screen_gap" "8")}
        general:border_size = ${(optionIfNull "border_width" "8")}
        decoration:rounding = ${(optionIfNull "border_radius" "2")}
      '';
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };
}
