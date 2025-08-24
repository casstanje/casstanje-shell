import QtQuick
import Quickshell

Rectangle {
    id: wrapper
    property real margin: 4
    required default property Item child
    property int borderWidthOverride: 1
    property color borderColorOverride: "#45475a"
    property color colorOverride: "transparent"
    
    border.width: borderWidthOverride
    border.color: borderColorOverride
    radius: 4
    color: colorOverride
    // Set the item's visual children list to just the passed item.
    children: [child]

    implicitWidth: child.implicitWidth + margin * 4
    implicitHeight: 25 // set to fixed height so all widget match eachother
    //child.implicitHeight + margin * 2

    // Bind the child's position and size.
    // Note that this syntax is exclusive to the Binding type.
    Binding { wrapper.child.x: wrapper.margin * 2 }
    Binding { wrapper.child.y: wrapper.margin }
    Binding { wrapper.child.width: wrapper.width - wrapper.margin * 4 }
    Binding { wrapper.child.height: wrapper.height - wrapper.margin * 2 }
}