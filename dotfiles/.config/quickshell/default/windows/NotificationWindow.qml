pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "./../"
import "./../elements/"

PopupWindow {
    id: root
    required property var notifications
    property var onEnteredCallback: function() {}
    property var onExitedCallback: function() {}
    property bool anyNotifications: false
    property bool dnd: false 
    property bool keepOpen: false
    property var barRoot
    property var button
    property int notifCount: 0
    color: "transparent"

    mask: Region { item: mouseArea }

    implicitWidth: barRoot.window.screen.width
    implicitHeight: barRoot.window.screen.height

    ClippingRectangle {
        x: root.button.parent.mapToItem(root.barRoot, root.button.x - implicitWidth + root.button.implicitWidth, 0).x
        y: root.barRoot.implicitHeight

        implicitHeight: container.implicitHeight
        color: "transparent"
        NumberAnimation on implicitHeight {
            id: spawnAnim
            running: root.visible
            from: 0; to: container.implicitHeight
            duration: 150
        }

        implicitWidth: container.implicitWidth
        WrapperMouseArea {
            id: mouseArea
            hoverEnabled: true
            onEntered: { root.onEnteredCallback() }
            onExited: { root.onExitedCallback() }
            Layout.maximumHeight: 800
            Layout.fillHeight: true

            WrapperRectangle {
                id: container
                margin: 8
                color: Theme.background
                radius: Theme.borderRadius
                border.width: Theme.borderWidth
                border.color: Theme.accent

                ColumnLayout {
                    spacing: 0
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: root.dnd ? "do not disturb is on" : (root.anyNotifications ? root.notifCount + " notfication" + (root.notifCount > 1 ? "s" : "") : "no notifications")
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pointSize: Theme.fontSize
                        }

                        Rectangle {
                            Layout.fillWidth: true
                        }
                        
                        ClickableContainer {
                            onClicked: {
                                root.button.dnd = !root.button.dnd
                            }
                            Text {
                                text: "dnd: " + (root.dnd ? "on" : "off")
                                font.family: Theme.fontFamily
                                font.pointSize: Theme.fontSize
                                color: Theme.text
                            }
                        }
                        Layout.bottomMargin: root.anyNotifications && !root.dnd ? 8 : 0
                    }
                    ScrollView {                
                        contentHeight: columnLayout.height
                        contentWidth: columnLayout.width
                        implicitHeight: root.dnd ? 0 : (columnLayout.height >  600 ? 600 : columnLayout.height)
                        implicitWidth: root.dnd ? 0 : columnLayout.width
                        ScrollBar.vertical.policy: ScrollBar.AlwaysOff


                        ColumnLayout {
                            id: columnLayout
                            Repeater {
                                model: root.notifications
                                id: notifRepeater
                                property var checkForNotifs: function(index, item){
                                    var anyNotifications = false
                                    var notifCount = 0
                                    if(notifRepeater.count > 0){
                                        for(var i = 0; i < notifRepeater.count; i++){
                                            var child = notifRepeater.itemAt(i)
                                            if(child.visible){
                                                anyNotifications = true
                                                notifCount += 1
                                            }
                                        }
                                    }
                                    root.anyNotifications = anyNotifications
                                    root.notifCount = notifCount
                                }
                                onItemAdded: checkForNotifs()
                                onItemRemoved: checkForNotifs()
                                ColumnLayout {
                                    required property var modelData
                                    visible: !modelData.transient && !modelData.lastGeneration
                                    id: notif
                                    RowLayout {
                                        Layout.minimumWidth: 250
                                        Layout.maximumWidth: 250
                                        ColumnLayout {
                                            RowLayout {
                                                visible: appName.visible
                                                spacing: 8

                                                RowLayout {
                                                    spacing: 6
                                                    IconImage {
                                                        visible: notif.modelData.appIcon != ""
                                                        Layout.alignment: Qt.AlignVCenter
                                                        id: appIcon
                                                        source: "file://" + notif.modelData.appIcon
                                                        implicitSize: 15
                                                    }
                                                    Text {
                                                        Layout.alignment: Qt.AlignVCenter
                                                        id: appName
                                                        text: notif.modelData.appName
                                                        color: Theme.text
                                                        font.family: Theme.fontFamily
                                                        font.pointSize: Theme.fontSize
                                                        font.bold: true
                                                        font.italic: false
                                                    }
                                                }
                                                Rectangle {
                                                    Layout.fillWidth: true
                                                }
                                                WrapperMouseArea{
                                                    Layout.alignment: Qt.AlignVCenter
                                                    property bool mouseOver: false
                                                    cursorShape: Qt.PointingHandCursor
                                                    hoverEnabled: true
                                                    onEntered: mouseOver = true
                                                    onExited: mouseOver = false
                                                    onClicked: notif.modelData.dismiss()
                                                    WrapperRectangle{
                                                        radius: Theme.borderRadius
                                                        color: parent.mouseOver ? Theme.brightSurface : Theme.error
                                                        leftMargin: (closeIcon.implicitHeight - closeIcon.implicitWidth) / 2
                                                        rightMargin: leftMargin
                                                        Text {
                                                            id: closeIcon
                                                            text: "" // Nerd Icons, nf-fa-close
                                                            color: Theme.background
                                                            font.family: Theme.fontFamily
                                                            font.pointSize: Theme.fontSize / 1.25
                                                        }
                                                    }
                                                }
                                            }
                                            RowLayout {
                                                Layout.maximumWidth: 250
                                                ClippingRectangle {
                                                    Layout.alignment: Qt.AlignTop
                                                    visible: notif.modelData.image != ""
                                                    color: "transparent"
                                                    id: imageContainer
                                                    implicitHeight: contentColumn.height
                                                    Layout.maximumHeight: (notifImage.paintedHeight < 60) ? 60 : notifImage.paintedHeight
                                                    implicitWidth: height
                                                    radius: Theme.borderRadius
                                                    Image {
                                                        id: notifImage
                                                        source: notif.modelData.image
                                                        height: imageContainer.height
                                                        width: imageContainer.height
                                                        fillMode: Image.PreserveAspectCrop
                                                    }
                                                }
                                                ColumnLayout {
                                                    id: contentColumn
                                                    Text {
                                                        visible: notif.modelData.summary != ""
                                                        text: notif.modelData.summary
                                                        color: Theme.text
                                                        font.family: Theme.fontFamily
                                                        font.pointSize: Theme.fontSize
                                                        wrapMode: Text.Wrap
                                                        elide: Text.ElideRight
                                                        Layout.fillWidth: true
                                                    }
                                                    Text {
                                                        visible: notif.modelData.body != ""
                                                        text: notif.modelData.body
                                                        color: Theme.subtext
                                                        font.family: Theme.fontFamily
                                                        font.pointSize: Theme.fontSize
                                                        wrapMode: Text.Wrap
                                                        elide: Text.ElideRight
                                                        Layout.maximumWidth: 150
                                                    }
                                                    GridLayout {
                                                        visible: notif.modelData.actions.length > 0
                                                        id: actionContainer
                                                        columnSpacing: 4
                                                        rowSpacing: 4
                                                        uniformCellWidths: true
                                                        columns: 2
                                                        Repeater {
                                                            id: actionsRepeater
                                                            model: notif.modelData.actions
                                                            ClickableContainer {
                                                                visible: actionContainer.modelData.text != ""
                                                                Layout.fillWidth: true
                                                                required property var modelData
                                                                id: actionContainer
                                                                onClicked: {
                                                                    try {
                                                                        modelData.invoke()
                                                                    } catch(e) {
                                                                        notif.modelData.dismiss()
                                                                    }
                                                                }
                                                                Text {
                                                                    elide: Text.ElideRight
                                                                    text: actionContainer.modelData.text
                                                                    color: Theme.text
                                                                    font.family: Theme.fontFamily
                                                                    font.pointSize: Theme.fontSize
                                                                    horizontalAlignment: Qt.AlignHCenter
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        Timer {
                                            interval: notif.modelData.expireTimeout
                                            onTriggered: notif.modelData.expire()
                                            running: notif.modelData.expireTimeout > 0
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        implicitHeight: 2
                                        radius: 1
                                        color: Theme.surface
                                    }
                                }
                            }
                        }
                    }

                    WrapperRectangle {
                        
                        Layout.fillWidth: true
                        color: Theme.background
                        topMargin: 8
                        RowLayout {
                            layoutDirection: Qt.RightToLeft
                            WrapperMouseArea {
                                visible: root.anyNotifications && ! root.dnd
                                hoverEnabled: true
                                property bool hoveredOver: false
                                onEntered: hoveredOver = true
                                onExited: hoveredOver = false

                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    var children = []
                                    for (var i = 0; i < notifRepeater.count; i++){
                                        children.push(notifRepeater.itemAt(i))
                                    }
                                    for (var child of children){
                                        child.modelData.dismiss()
                                    }
                                }
                                WrapperRectangle {
                                    margin: 8
                                    border.color: Theme.error
                                    border.width: 1
                                    color: parent.hoveredOver ? Theme.surface : "transparent"
                                    radius: Theme.borderRadius

                                    Text {
                                        text: "clear all"
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize
                                        color: Theme.error
                                    }
                                }
                            }
                            
                            Rectangle {
                                Layout.fillWidth: true
                            }

                        }
                    }
                }
                
            }
        }
    }
    
}
