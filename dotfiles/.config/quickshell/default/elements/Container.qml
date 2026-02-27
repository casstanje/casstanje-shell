import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import "./../"

WrapperRectangle {
    default required property var child
    color: "transparent"
    margin: Theme.containerPadding
    leftMargin: Theme.containerPadding * 2
    rightMargin: Theme.containerPadding * 2
    radius: Theme.borderRadius
    border.width: Theme.smallBorderWidth
    border.color: Theme.surface

    children: [child]
}