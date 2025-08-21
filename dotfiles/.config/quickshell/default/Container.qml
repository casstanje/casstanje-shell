import QtQuick
import Quickshell

Rectangle {
    id: wrapper
    property real margin: 4
    required default property Item child

    border.width: 1
    border.color: "#45475a"
    radius: 4
    color: "transparent"

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