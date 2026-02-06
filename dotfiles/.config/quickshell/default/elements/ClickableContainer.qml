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
    property color hoverBackgroundColor: Theme.brightSurface
    property bool hasBorder: true
    property double radius: Theme.borderRadius

    hoverEnabled: true
    property bool hoveredOver: false
    onEntered: hoveredOver = true
    onExited: hoveredOver = false
    cursorShape: Qt.PointingHandCursor

    WrapperRectangle {
        id: rectangle
        color: hoveredOver ? root.hoverBackgroundColor : root.backgroundColor
        margin: Theme.containerPadding
        leftMargin: Theme.containerPadding * 2
        rightMargin: Theme.containerPadding * 2
        radius: root.radius
        border.width: root.hasBorder ? Theme.smallBorderWidth : 0
        border.color: Theme.surface
        children: [root.child]
    }
}