import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import './../'

ToolTip {
    visible: visible
    parent: parent
    delay: 500
    y: parent.implicitHeight + 4
    popupType: Popup.Window
    background: WrapperRectangle {
        margin: 4
        radius: Theme.borderRadius
        border.color: Theme.accent
        border.width: Theme.borderWidth
        color: Theme.background
    }
}