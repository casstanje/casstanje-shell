pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "./../"
import "./../elements/"

PopupWindow {
    id: root
    required property var notifications
    property var onEnteredCallback: function() {}
    property var onExitedCallback: function() {}
    property bool anyNotifications: false
    property bool dnd: false 
    property var barRoot
    property var button
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
            WrapperRectangle {
                id: container
                margin: 8
                color: Theme.background
                radius: Theme.borderRadius
                border.width: Theme.borderWidth
                border.color: Theme.accent


                ColumnLayout {
                    RowLayout {
                        visible: !root.anyNotifications || root.dnd
                        Text {
                            text: root.dnd ? "do not disturb is on" : "no notifications"
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pointSize: Theme.fontSize
                        }
                    }
                    Repeater {
                        model: root.notifications
                        id: notifRepeater
                        property var checkForNotifs: function(index, item){
                            var anyNotifications = false
                            if(notifRepeater.count > 0){
                                for(var i = 0; i < notifRepeater.count; i++){
                                    var child = notifRepeater.itemAt(i)
                                    if(child.visible){
                                        anyNotifications = true
                                    }
                                }
                            }
                            root.anyNotifications = anyNotifications
                        }
                        onItemAdded: checkForNotifs()
                        onItemRemoved: checkForNotifs()
                        Container {
                            required property var modelData
                            visible: !modelData.transient && !modelData.lastGeneration
                            id: notif
                            margin: 8
                            border.width: 2
                            border.color: Theme.brightSurface
                            Layout.minimumWidth: 250
                            RowLayout {
                                ColumnLayout {
                                    RowLayout {
                                        visible: appName.visible
                                        spacing: 8

                                        RowLayout {
                                            spacing: 6
                                            IconImage {
                                                Layout.alignment: Qt.AlignVCenter
                                                visible: notif.modelData.appIcon != ""
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
                                                font.pointSize: Theme.fontSize * 1.05
                                                font.bold: true
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
					    Layout.maximumHeight: 60
                                            implicitWidth: height
                                            radius: Theme.borderRadius
                                            Image {
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
                                            RowLayout {
                                                visible: notif.modelData.actions.length > 0
                                                spacing: 4
                                                Repeater {
                                                    id: actionsRepeater
                                                    model: notif.modelData.actions
                                                    ClickableContainer {
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

                        }
                    }
                }
            }
        }
    }
    
}
