{ config, pkgs, ctpFlavor, ctpAccent, ... }:
let
  shellColorString = if ctpAccent == "green" then
    "green"
  else if ctpAccent == "mauve" || ctpAccent == "pink" || ctpAccent == "lavender" then
    "magenta"
  else if ctpAccent == "sapphire" || ctpAccent == "blue" then
    "blue"
  else if ctpAccent == "yellow" then
    "yellow"
  else if ctpAccent == "sky" || ctpAccent == "teal" then
    "cyan"
  else
    "red";

  shellColor = if shellColorString == "green" then
    "32"
  else if shellColorString == "magenta" then
    "35"
  else if shellColorString == "blue" then
    "34"
  else if shellColorString == "yellow" then
    "33"
  else if shellColorString == "cyan" then
    "36"
  else
    "31";
in
{
  home.file.".bashrc".source = ./../dotfiles/.bashrc;
  home.file.".dircolors".source = ./../dotfiles/.dircolors;

  catppuccin.kitty.enable = true;

  programs.fastfetch.enable = true;

  programs.kitty = {
    enable = true;

    settings = {
      window_margin_width = 5;
    };
  };

  programs.zsh = {
    enable = true; 
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    initContent = ''
      source "$HOME/.bashrc"
      PROMPT="$USER@$(hostname) %2~ $ "
      RPROMPT="%F{8}%*%f"
      osName=$(fastfetch -s os --format json | jq -r '.[0].result.name')
      color="\033[0;${shellColor}m"
      printf "$color$(figlet -f smslant $osName)\033[0m\n" && fastfetch -l none
    '';
  };

  xdg.configFile."fastfetch/config.jsonc" = {
    text = ''
      {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.jsonc",
        "display": {
          "separator": ": ",
          "color": {
            "keys": "italic_bold_${shellColorString}",
            "title": "bright_bold_${shellColorString}"
          }
        },
        "modules": [
          "title",
          "separator",
          "os",
          "kernel",
          "host",
          "localip",
          "separator",
          "cpu",
          "gpu",
          "battery",
          "separator",
          "swap",
          "memory",
          "disk",
          "separator",
          "packages",
          "shell",
          "terminal",
          "separator",
          "wm",
          "display",
          "break"
        ]
      }
    '';
  };
}
