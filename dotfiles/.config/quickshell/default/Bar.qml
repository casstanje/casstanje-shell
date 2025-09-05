pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

import "./windows/"
import "./elements/"
import "./functions/"
import "./systray/"

Scope {
    id: root
    
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 50

            color: "transparent"

            property var mouseClicked: UserInfo.mouseClicked

            property var closeAllPopups: function() {
                if(UIVars.closePopupFunctions.length > 0){
                    var functionsToRemove = [];
                    for (var closeFunction of UIVars.closePopupFunctions) {
                        var res = closeFunction()
                        if(res) {
                            functionsToRemove.push(UIVars.closePopupFunctions.indexOf(closeFunction))
                        }
                    }
                    for (var funtionToRemove of functionsToRemove){
                        UIVars.closePopupFunctions.splice(functionsToRemove, 1)
                    }
                }
            }

            onMouseClickedChanged: function() {
                closeAllPopups()
            }

            WrapperRectangle {
                margin: 8
                bottomMargin: 0
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: "transparent"
                id: barRoot
                property var closeAllPopups: window.closeAllPopups
                property var window: window

                WrapperRectangle {
                    color: Theme.background


                    radius: Theme.borderRadius

                    border.width: Theme.borderWidth
                    border.color: Theme.accent
                    WrapperRectangle {
                        leftMargin: 8
                        rightMargin: 8
                        bottomMargin: 0
                        topMargin: 0
                        color: "transparent"

                        RowLayout {
                            spacing: 0
                            id: bar
                            // Left Content
                            RowLayout {
                                spacing: Theme.listSpacing
                                Layout.maximumWidth: bar.width / 3
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                UserInfoButton {
                                    visible: Config.startMenuEnabled
                                    barRoot: barRoot
                                }
                                Battery { 
                                    barRoot: barRoot
                                }
                                VolumeControl {
                                    visible: Config.volumeEnabled
                                    barRoot: barRoot
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                }
                            }

                            // Center Content
                            RowLayout {
                                spacing: Theme.listSpacing
                                Layout.maximumWidth: bar.width / 3
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                MprisBar {
                                    barRoot: barRoot
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }

                            // Right Content
                            RowLayout {

                                spacing: Theme.listSpacing
                                Layout.maximumWidth: bar.width / 3
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                
                                Rectangle {
                                    Layout.fillWidth: true
                                }
                                SysTrayBar {
                                    barRoot: barRoot
                                    visible: Config.sysTrayEnabled
                                }
                                NotificationsButton { 
                                    id: notifButton
                                    barRoot: barRoot
                                    visible: Config.notificationsEnabled
                                }
                                Clock { 
                                    id: clock
                                    visible: Config.clockEnabled
                                }
                            }
                        }
                    }
                }

            }
        }
    }
    
}
