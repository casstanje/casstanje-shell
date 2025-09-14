import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import "./../"

WrapperMouseArea {
    id: root
    default required property var child
    property var rectangle: rectangle
    property color backgroundColor: "transparent"
    property bool hasBorder: true

    hoverEnabled: true
    property bool hoveredOver: false
    onEntered: hoveredOver = true
    onExited: hoveredOver = false
    cursorShape: Qt.PointingHandCursor

    WrapperRectangle {
        id: rectangle
        color: hoveredOver ? Theme.brightSurface : root.backgroundColor
        margin: Theme.containerPadding
        leftMargin: Theme.containerPadding * 2
        rightMargin: Theme.containerPadding * 2
        radius: Theme.borderRadius
        border.width: root.hasBorder ? Theme.smallBorderWidth : 0
        border.color: Theme.surface
        children: [root.child]
    }
}