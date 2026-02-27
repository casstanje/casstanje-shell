{ config, pkgs, ctpFlavor, ctpAccent, ... }:
let
  catppuccin-gtk-pkg = (pkgs.catppuccin-gtk.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "gtk";
      rev = "v1.0.3";
      fetchSubmodules = true;
      hash = "sha256-q5/VcFsm3vNEw55zq/vcM11eo456SYE5TQA3g2VQjGc=";
    };

    postUnpack = "";
  }).override {
    accents = [ "${ctpAccent}" ];
    variant = "${ctpFlavor}";
    size = "compact";
  };

  kvantumThemePackage = pkgs.catppuccin-kvantum.override {
    variant = ctpFlavor;
    accent = ctpAccent;
  };
in
{
  catppuccin.gtk.icon = {
    enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style.name = "kvantum";

    qt6ctSettings = {
      Appearance = {
        style = "kvantum-dark";
        icon_theme = "Papirus-Dark";
        color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/style-colors.conf";
        custom_palette = true;
        standard_dialogs = "xdgdesktopportal";
      };
      Fonts = {
        fixed = "\"JetBrainsMono Nerd Font,10\"";
        general = "\"JetBrainsMono Nerd Font,10\"";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-${ctpFlavor}-${ctpAccent}-compact";
      package = catppuccin-gtk-pkg;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-${ctpFlavor}-${ctpAccent}

      # ${kvantumThemePackage}
    '';
    "Kvantum/catppuccin-${ctpFlavor}-${ctpAccent}".source = "${kvantumThemePackage}/share/Kvantum/catppuccin-${ctpFlavor}-${ctpAccent}";
  };
}
