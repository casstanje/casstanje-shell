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
import Quickshell.Hyprland
import QtQml.Models
import Quickshell.Wayland

import "./windows/"
import "./elements/"
import "./singletons/"
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

            WrapperRectangle {
                margin: Theme.screenGap
                bottomMargin: 0
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: "transparent"
                id: barRoot
                property var window: window

                Component.onCompleted: {
                    DynamicVars.barHeight = height
                    console.log("Bar Height = " + DynamicVars.barHeight)
                }

                WrapperRectangle {
                    color: Theme.background


                    radius: Theme.borderRadius

                    border.width: Theme.borderWidth
                    border.color: Theme.accent
                    WrapperRectangle {
                        leftMargin: 8
                        rightMargin: 8
                        bottomMargin: 2
                        topMargin: 0
                        color: "transparent"

                        RowLayout {
                            spacing: 0
                            id: bar
                            Layout.alignment: Qt.AlignHCenter
                            // Left Content
                            RowLayout {
                                spacing: Theme.listSpacing
                                Layout.maximumWidth: bar.width / 3
                                Layout.maximumHeight: Theme.fontSize + Theme.containerPadding * 6
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
                                Container {
                                    visible: Config.memEnabled && UserInfo.memoryUsage != ""
                                    Text {
                                        text: "mem " + UserInfo.memoryUsage
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize
                                    }
                                }
                                Container {
                                    visible: Config.cpuEnabled && UserInfo.cpuUsage != ""
                                    Text {
                                        text: "cpu " + UserInfo.cpuUsage
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize
                                    }
                                }
                                Workspaces {}
                                Rectangle {
                                    Layout.fillWidth: true
                                }
                            }

                            // Center Content
                            RowLayout {
                                spacing: Theme.listSpacing
                                Layout.maximumWidth: bar.width / 3
                                Layout.maximumHeight: Theme.fontSize + Theme.containerPadding * 6
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                MprisBar {
                                    Layout.fillWidth: true
                                    barRoot: barRoot
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }

                            // Right Content
                            RowLayout {
                                spacing: Theme.listSpacing
                                Layout.maximumWidth: bar.width / 3
                                Layout.maximumHeight: Theme.fontSize + Theme.containerPadding * 6
                                Layout.fillWidth: true
                                
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
