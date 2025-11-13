pragma Singleton
import Quickshell

Singleton {
    id: root

    /*BAR ITEMS*/

    // Left Side
    property bool startMenuEnabled: true
    // Automatically hidden if not on laptop.
    // Also includes a menu with options for screen brightness and power profiles
    property bool showLaptopBattery: true
    // If the computer is NOT a laptop and this is true, 
    // the battery indicator gets switched out with a 
    // power menu where you can switch power profile and screen brightness (if your system supports that).
    property bool showPowerMenu: true
    property bool volumeEnabled: true
    property bool memEnabled: true
    property bool cpuEnabled: true

    // Center Side
    property bool mprisBarEnabled: true

    // Right Side
    property bool sysTrayEnabled: true
    property bool notificationsEnabled: true
    property bool clockEnabled: true

    /* Desktop Widgets */
    property bool desktopMediaPlayerEnabled: false

    /*SPECIFIC MODULE SETTINGS*/

    //Clock
    // https://doc.qt.io/qt-6/qml-qtqml-qt.html#formatDateTime-method
    property string dateTimeFormat: "ddd dd/MM/yy | hh:mm:ss"

    // System Tray
    // Maximum of 18 (if you want them to actually fit in the container lol)
    property int trayIconSize: 13

    // Notfications
    property int notificationDuration: 3500

    // Battery
    // Shows a background that's filled in according to the charge percentage
    property bool showBatteryChargeBg: true
    // Enables a menu on the battery module, that allows you to change the power profile of your pc
    // You need to have the power-profiles-daemon installed and running for it to work.
    // Gets disabled automatically if the daemon doesn't exist
    property bool enablePowerProfileControl: true
    // Adds a slider for brightnessctl to the power menu
    // Also enables the menu if power profile control isn't enabled
    // Gets disabled automatically if brightnessctl isn't found
    property bool enableBrightnessControl: true
    // The device you would like the slider to affect. This varies from device to device, but the most common seems to be 'intel_backlight'.
    property string backlightDeviceName: "intel_backlight"

    // Mpris
    property int albumArtMenuSize: 250
    property bool showAlbumArt: true
    // Shows a background that's filled in according to the song progress
    // around the song title - artist - album
    property bool showPosition: true
    // The maximum width of the mpris bar's text in integers. The clipped text gets elided with three . (dots)
    // If set to null, the bar will have a maximum width equals to one third of the full bar
    property int maximumWidth: 0
    // These does not work with most players, even if the players report that they do, so they are disabled by default
    property bool showShuffleButton: false
    property bool showRepeatButton: false
    property bool showVolumeSlider: false
}