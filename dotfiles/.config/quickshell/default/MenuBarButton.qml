import Quickshell
import QtQuick
import Quickshell.Widgets

WrapperMouseArea {
    id: root

    default required property var child

    hoverEnabled: true
    property bool hoveredOver: false
    onEntered: hoveredOver = true
    onExited: hoveredOver = false
    
    WrapperRectangle {
        topLeftRadius: Theme.borderRadius
        topRightRadius: topLeftRadius

        color: root.hoveredOver ? Theme.brightSurface : Theme.surface
        margin: Theme.containerPadding * 4

        children: [root.child]
    }
}