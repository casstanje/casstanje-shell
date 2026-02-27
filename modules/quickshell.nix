{ config, pkgs, ctpFlavor, ctpAccent, optionIfNull, ... }:
{
  home.packages = with pkgs; [
    # Custom scripts
    (writeShellApplication { # Run from hyprland on reload. Reloads quickshell
      name = "reloadQs";
      text = ''
        if pgrep quickshell > /dev/null ; then
          pkill quickshell > /dev/null
        fi
        quickshell -d
      '';
    })
  ];

  xdg.configFile = {
    "quickshell" = {
      source = ./../dotfiles/.config/quickshell;
      recursive = true;
    };
    "quickshell/default/Theme.qml" = {
      text = ''
        pragma Singleton

        import Quickshell
        import Quickshell.Io
        import QtQuick

        Singleton {
          id: root
          // Colors
          property color background: ColorScheme.base
          property color text: ColorScheme.text
          property color subtext: ColorScheme.subtext0
          property color darkerBackground: ColorScheme.mantle
          property color accent: ColorScheme.${ctpAccent}
          property color surface: ColorScheme.surface0
          property color brightSurface: ColorScheme.surface1
          property color error: ColorScheme.red 
          property color correct: ColorScheme.green 

          // Values
          property int borderRadius: ${(optionIfNull "border_radius" "4")}
          property int borderWidth: ${(optionIfNull "border_width" "2")}
          property real smallBorderWidth: 1
          property double listSpacing: 2
          property real containerPadding: 3
          property int screenGap: ${(optionIfNull "screen_gap" "8")}

          // Font
          property string fontFamily: "JetBrainsMono Nerd Font"
          property real fontSize: 10
        }
      '';
    };
    "quickshell/default/Config.qml" = {
      text = ''
        pragma Singleton
        import Quickshell

        Singleton {
          id: root

          /*BAR ITEMS*/

          // Left Side
          property bool startMenuEnabled: ${(optionIfNull "start_menu_enabled" "true")}
          // Automatically hidden if not on laptop.
          // Also includes a menu with options for screen brightness and power profiles
          property bool showLaptopBattery: ${(optionIfNull "show_laptop_battery" "true")}
          // If the computer is NOT a laptop and this is true, 
          // the battery indicator gets switched out with a 
          // power menu where you can switch power profile and screen brightness (if your system supports that).
          property bool showPowerMenu: ${(optionIfNull "show_power_menu" "true")}
          property bool volumeEnabled: ${(optionIfNull "volume_enabled" "true")}
          property bool memEnabled: ${(optionIfNull "memory_usage_enabled" "true")}
          property bool cpuEnabled: ${(optionIfNull "cpu_usage_enable" "true")}
          property bool workspacesEnabled: ${(optionIfNull "workspaces_enabled" "true")}

          // Center Side
          property bool mprisBarEnabled: ${(optionIfNull "mpris_bar_enabled" "true")}

          // Right Side
          property bool sysTrayEnabled: ${(optionIfNull "system_tray_enabled" "true")}
          property bool notificationsEnabled: ${(optionIfNull "notifications_enabled" "true")}
          property bool clockEnabled: ${(optionIfNull "bar_clock_enabled" "true")}

          /* Desktop Widgets */
          property bool desktopMediaPlayerEnabled: ${(optionIfNull "mpris_player_enabled" "false")}
          property bool desktopClockEnabled: ${(optionIfNull "clock_enabled" "false")}

          /*SPECIFIC MODULE SETTINGS*/

          //Clock
          // https://doc.qt.io/qt-6/qml-qtqml-qt.html#formatDateTime-method
          property string dateTimeFormat: "${(optionIfNull "date_time_format" "ddd dd/MM/yy | hh:mm:ss")}"

          // System Tray
          // Maximum of 18 (if you want them to actually fit in the container lol)
          property int trayIconSize: ${(optionIfNull "tray_icon_size" "13")}

          // Notfications
          property int notificationDuration: ${(optionIfNull "notification_duration" "3500")}

          // Battery
          // Shows a background that's filled in according to the charge percentage
          property bool showBatteryChargeBg: ${(optionIfNull "show_battery_charge_background" "true")}
          // Enables a menu on the battery module, that allows you to change the power profile of your pc
          // You need to have the power-profiles-daemon installed and running for it to work.
          // Gets disabled automatically if the daemon doesn't exist
          property bool enablePowerProfileControl: ${(optionIfNull "enable_power_profile_control" "true")}
          // Adds a slider for brightnessctl to the power menu
          // Also enables the menu if power profile control isn't enabled
          // Gets disabled automatically if brightnessctl isn't found
          property bool enableBrightnessControl: ${(optionIfNull "enable_brightness_control" "true")}
          // The device you would like the slider to affect. This varies from device to device, but the most common seems to be 'intel_backlight'.
          property string backlightDeviceName: "${(optionIfNull "backlight_device_name" "intel_backlight")}"

          // Workspaces
          property bool showOnlyIds: ${(optionIfNull "show_only_ids" "false")}
          
          // Mpris
          property int albumArtMenuSize: ${(optionIfNull "album_art_menu_size" "250")}
          property bool showAlbumArt: ${(optionIfNull "show_album_art" "true")}
          // Shows a background that's filled in according to the song progress
          // around the song title - artist - album
          property bool showPosition: ${(optionIfNull "show_position" "true")}
          // The maximum width of the mpris bar's text in integers. The clipped text gets elided with three . (dots)
          // If set to null, the bar will have a maximum width equals to one third of the full bar
          property int maximumWidth: ${(optionIfNull "maximum_width" "0")}
          // These does not work with most players, even if the players report that they do, so they are disabled by default
          property bool showShuffleButton: ${(optionIfNull "show_shuffle_button" "false")}
          property bool showRepeatButton: ${(optionIfNull "show_repeat_button" "false")}
          property bool showVolumeSlider: ${(optionIfNull "show_volume_slider" "false")}
        }

      '';
    };
  };
}
