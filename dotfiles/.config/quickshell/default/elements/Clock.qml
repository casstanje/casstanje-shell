import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import "./../"
import "./../singletons/"
import "./"

Container {
    color: "transparent"
    Text {
        text: Time.time
        color: Theme.text
        font.family: Theme.fontFamily
        font.pointSize: Theme.fontSize
    }
}
