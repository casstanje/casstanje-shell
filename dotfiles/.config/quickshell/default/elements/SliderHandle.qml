import QtQuick
import './../'
Rectangle {
    x: parent.visualPosition * (parent.availableWidth - width)
    y: parent.availableHeight / 2 - height / 2
    implicitWidth: 16
    implicitHeight: 16
    radius: 8
    color: parent.pressed ? Theme.brightSurface : Theme.surface
    border.color: Theme.brightSurface
}