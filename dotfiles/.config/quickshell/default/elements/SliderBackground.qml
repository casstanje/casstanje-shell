import QtQuick
import './../'
Rectangle {

    implicitHeight: 7
    height: implicitHeight
    y: parent.height / 2 - height / 2
    implicitWidth: parent.availableWidth
    radius: Theme.borderRadius
    color: Theme.surface

    Rectangle {
        implicitWidth: parent.parent.visualPosition * parent.implicitWidth
        height: parent.height
        color: Theme.accent
        radius: Theme.borderRadius
    }
}