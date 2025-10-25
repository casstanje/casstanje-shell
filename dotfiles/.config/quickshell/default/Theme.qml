pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property color rosewater: "#f5e0dc"

    property color flamingo: "#f2cdcd"

    property color pink: "#f5c2e7"

    property color mauve: "#cba6f7"

    property color red: "#f38ba8"

    property color maroon: "#eba0ac"

    property color peach: "#fab387"

    property color yellow: "#f9e2af"

    property color green: "#a6e3a1"

    property color teal: "#94e2d5"

    property color sky: "#89dceb"

    property color sapphire: "#74c7ec"

    property color blue: "#89b4fa"

    property color lavender: "#b4befe"

    property color text: "#cdd6f4"

    property color subtext1: "#bac2de"

    property color subtext0: "#a6adc8"

    property color overlay2: "#9399b2"

    property color overlay1: "#7f849c"

    property color overlay0: "#6c7086"

    property color surface2: "#585b70"

    property color surface1: "#45475a"

    property color surface0: "#313244"

    property color base: "#1e1e2e"

    property color mantle: "#181825"

    property color crust: "#11111b"

    // Colors
    property color background: base
    property color subtext: subtext0
    property color darkerBackground: mantle
    property color accent: green
    property color surface: surface0
    property color brightSurface: surface1
    property color error: red 
    property color correct: green 

    // Values
    property int borderRadius: 4
    property int borderWidth: 2
    property real smallBorderWidth: 1
    property double listSpacing: 4
    property real containerPadding: 2
    property int screenGap: 8

    // Font
    property string fontFamily: "JetBrainsMono Nerd Font"
    property real fontSize: 10
}