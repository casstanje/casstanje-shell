import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "./"
import "./../"
import "./../windows/"
import "./../singletons/"

ClickableContainer {
    id: root


    required property var barRoot
    property bool showWindow: false
    property point windowPosition: [0, 0]
    property bool windowHoveredOver: false
    property bool hoveredOver: false
    property bool dnd: false

    hoverEnabled: true
    onEntered: hoveredOver = true
    onExited: hoveredOver = false
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    property var currentNotification: {
        "appName": "",
        "body": "",
        "summary": "",
        "image": "",
        "actions": [],
        "urgency": null,
        "appIcon": ""
    }

    onClicked: function(mouse) {
        if(mouse.button != Qt.LeftButton){
            root.windowPosition = mapToItem(root.barRoot, root.x, root.y)
            root.showWindow = true
            UIVars.closePopupFunctions.push(function():Boolean{ 
                if(!root.windowHoveredOver && !root.hoveredOver && !notifWindow.keepOpen){
                    root.showWindow = false
                    return true
                }else return false
            })
        }else {
            dnd = !dnd
        }
    }

    WrapperRectangle {
        color: "transparent"

        Text {
            text: root.dnd ? "" : "" // Nerd Icons, nf-fa-bell_slash : nf-fa-bell
            color: notifWindow.anyNotifications && !notifWindow.dnd ? Theme.error : Theme.text
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
        }

        NotificationServer {
            id: notifServer
            bodyImagesSupported: true
            persistenceSupported: true
            actionsSupported: true
            onNotification: {
                notification.tracked = true
                root.currentNotification = {
                    "appName": notification.appName,
                    "body": notification.body,
                    "summary": notification.summary,
                    "image": notification.image,
                    "actions": notification.actions,
                    "urgency": notification.urgency,
                    "appIcon": notification.appIcon
                }
                if(!root.showWindow && !notification.lastGeneration && !root.dnd) appearAnim.running = true
            }
        }
        

        NotificationWindow {
            id: notifWindow
            visible: root.showWindow
            notifications: notifServer.trackedNotifications
            onEnteredCallback: function(){
                root.windowHoveredOver = true
            }
            onExitedCallback: function(){
                root.windowHoveredOver = false
            }
            dnd: root.dnd
            anchor {
                window: root.barRoot.window
                rect.x: 0
                rect.y: 0
            }
            barRoot: root.barRoot
            button: root
        }

        Tooltip {
            parent: root
            visible: root.hoveredOver
            text: "left: toggle dnd\nright: open menu"
        }
        
        PopupWindow {
            visible: !root.dnd && Config.notificationsEnabled
            anchor {
                window: root.barRoot.window
                rect.width: root.width
                rect.height: root.height
                rect.x: root.barRoot.window.screen.width
                rect.y: root.barRoot.implicitHeight + 4
            }
            implicitHeight: container.implicitHeight
            implicitWidth: container.implicitWidth

            color: "transparent"

            WrapperRectangle{
                id: container
                margin: 8
                color: popupMouseArea.hoveredOver ? Theme.surface : Theme.background
                radius: Theme.borderRadius
                border.width: Theme.borderWidth
                border.color: Theme.accent
                x: container.implicitWidth
                NumberAnimation on x {
                    onStarted: {
                        waitAnim.stop()
                        closeAnim.stop()
                    }
                    id: appearAnim
                    from: container.implicitWidth; to: 0;
                    running: false
                    duration: 150
                    onFinished: {
                        waitAnim.running = true
                    }
                }

                NumberAnimation on x {
                    onStarted: {
                        closeAnim.stop()
                    }
                    id: waitAnim
                    from: 0; to: 0;
                    running: false
                    duration: Config.notificationDuration
                    onFinished: {
                        closeAnim.running = true
                    }
                }

                NumberAnimation on x {
                    id: closeAnim
                    from: 0; to: container.implicitWidth;
                    running: false
                    duration: 150
                    onFinished: {
                        root.currentNotification = {
                            "appName": "",
                            "body": "",
                            "summary": "",
                            "image": "",
                            "actions": [],
                            "urgency": null,
                            "appIcon": ""
                        }
                    }
                }

                WrapperMouseArea {
                    id: popupMouseArea
                    cursorShape: root.currentNotification.actions.length > 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
                    property bool hoveredOver: false
                    hoverEnabled: true

                    onEntered: {
                        if(root.currentNotification.actions.length > 0)
                            hoveredOver = true
                    }

                    onExited: {
                        hoveredOver = false
                    }

                    onClicked: {
                        root.currentNotification.actions[0].invoke()
                        appearAnim.stop()
                        waitAnim.stop()
                        closeAnim.start()
                    }

                    RowLayout {
                        ClippingRectangle {
                            visible: root.currentNotification.image != ""
                            color: "transparent"
                            id: imageContainer
                            implicitWidth: 40
                            implicitHeight: implicitWidth
                            radius: Theme.borderRadius
                            Image {
                                source: root.currentNotification.image
                                height: imageContainer.implicitHeight
                                width: imageContainer.implicitHeight
                                fillMode: Image.PreserveAspectCrop
                            }
                        }
                        ColumnLayout {
                            spacing: 0
                            RowLayout {
                                visible: appName.visible
                                spacing: 2

                                IconImage {
                                    visible: root.currentNotification.appIcon != ""
                                    id: appIcon
                                    source: root.currentNotification.appIcon
                                }
                                Text {
                                    id: appName
                                    text: root.currentNotification.appName
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize * 1.05
                                    wrapMode: Text.Wrap
                                    font.bold: false
                                }
                            }
                            Text {
                                text: root.currentNotification.body == "" ? root.currentNotification.summary : root.currentNotification.body
                                color: Theme.subtext
                                font.family: Theme.fontFamily
                                font.pointSize: Theme.fontSize
                                wrapMode: Text.NoWrap
                                elide: Text.ElideRight
                                Layout.maximumWidth: 150
                            }
                        }
                    }
                }

            }

        }
    }

}