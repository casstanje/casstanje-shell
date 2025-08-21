import QtQuick
import QtQuick.Controls
import Quickshell

MouseArea {
    id: mouseArea
    implicitWidth: wrapper.width
    implicitHeight: wrapper.height
    property var clickAction: function () {}
    property var rightClickAction: function () {}
    property var wheelUpAction: function () {}
    property var wheelDownAction: function () {}
    property int maxWidth: 0
    required default property Item child
    property bool hovered: false
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onPressed: function(mouse) {
        if(mouse.button == Qt.LeftButton){
            if(clickAction != undefined) clickAction()
        }else if(mouse.button == Qt.RightButton){
            console.log("wow")
            if(rightClickAction != undefined) rightClickAction()
        }
    }

    onWheel: {
        if(wheel.angleDelta.y > 0){
            if(wheelUpAction != undefined)  wheelUpAction()
        }else{
            if(wheelDownAction != undefined) wheelDownAction()
        }
    }

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onEntered: hovered = true
    onExited: hovered = false
    Rectangle {
        id: wrapper
        property real margin: 4

        border.width: 1
        border.color: "#45475a"
        radius: 4
        color: mouseArea.containsMouse ? "#313244" : "transparent"

        // Set the item's visual children list to just the passed item.
        children: [mouseArea.child]
        

        implicitWidth: (
                mouseArea.maxWidth != 0 ? 
                (
                    mouseArea.child.implicitWidth + margin * 4 > mouseArea.maxWidth ? 
                    mouseArea.maxWidth : 
                    mouseArea.child.implicitWidth + margin * 4
                ) : 
                mouseArea.child.implicitWidth + margin * 4
            )
        implicitHeight: 25 // set to fixed height so all widget match eachother
        //child.implicitHeight + margin * 2

        // Bind the child's position and size.
        // Note that this syntax is exclusive to the Binding type.
        Binding { mouseArea.child.x: wrapper.margin * 2 }
        Binding { mouseArea.child.y: wrapper.margin }
        Binding { mouseArea.child.width: wrapper.width - wrapper.margin * 4 }
        Binding { mouseArea.child.height: wrapper.height - wrapper.margin * 2 }
    }

    Rectangle {
        id: tooltipHolder
        y: 100
    }
}