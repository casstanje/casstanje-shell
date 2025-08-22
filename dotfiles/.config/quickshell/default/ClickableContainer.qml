import QtQuick
import QtQuick.Controls
import Quickshell

MouseArea {
    id: mouseArea
    property var bar: QsWindow.window
    implicitWidth: wrapper.width
    implicitHeight: wrapper.height
    property var clickAction: function () {}
    property var rightClickAction: function () {}
    property var wheelUpAction: function () {}
    property var wheelDownAction: function () {}
    property int maxWidth: 0
    required default property Item child
    property bool hovered: false
    property string tooltip: ""
    property int tooltipExtraTopMargin: 0
    property bool tooltipVisible: {
        hovered && tooltip != ""
    }
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onPressed: function(mouse) {
        if(mouse.button == Qt.LeftButton){
            if(clickAction != undefined) clickAction()
        }else if(mouse.button == Qt.RightButton){
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

    PopupWindow {
        anchor.window: mouseArea.bar
        visible: mouseArea.tooltipVisible
        anchor.rect.x: mouseArea.parent.mapToGlobal(mouseArea.x, mouseArea.y).x + wrapper.width / 2 - width / 2
        anchor.rect.y: mouseArea.parent.mapToGlobal(mouseArea.x, mouseArea.y).y + wrapper.height + 5 + mouseArea.tooltipExtraTopMargin
        implicitWidth: tooltipWrapper.width
        implicitHeight: tooltipWrapper.height
        color: "transparent"

        Rectangle {
            id: tooltipWrapper
            property real margin: 4
            property var tooltipChild: Text{
                text: mouseArea.tooltip
                color: "#cdd6f4"
                font.family: "JetBrainsMono"
                font.bold: true
                font.pointSize: 10
                x: tooltipWrapper.margin * 2
                y: tooltipWrapper.margin
                width: width - tooltipWrapper.margin * 4
                height: height - tooltipWrapper.margin * 2
            }

            border.width: 2
            border.color: "#a6e3a1"
            radius: 4
            color: "#1e1e2e"

            // Set the item's visual children list to just the passed item.
            children: [tooltipChild]
            

            implicitWidth: tooltipChild.implicitWidth + margin * 4
                
            implicitHeight: 25 // set to fixed height so all widget match eachother
            //child.implicitHeight + margin * 2
        }
    }
}