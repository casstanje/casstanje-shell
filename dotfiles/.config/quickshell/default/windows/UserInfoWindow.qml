import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "./../"
import "./../functions"
import "./../elements"

PopupWindow {
    id: root
    property var onEnteredCallback: function () {}
    property var onExitedCallback: function () {}
    property var closeWindow: function () {}
    property var barRoot
    property var button
    implicitWidth: barRoot.window.screen.width
    implicitHeight: barRoot.window.screen.height
    color: "transparent"

    mask: Region { item: mouseArea }

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true
        onEntered: {
            root.onEnteredCallback();
        }
        onExited: {
            root.onExitedCallback();
        }

        x: Math.round(root.barRoot.leftMargin * 2)
        y: Math.round(root.barRoot.implicitHeight)
        ClippingRectangle {
            implicitWidth: container.implicitWidth
            implicitHeight: container.implicitHeight

            color: "transparent"
            NumberAnimation on implicitHeight {
                id: spawnAnim
                running: root.visible
                from: 0
                to: container.implicitHeight
                duration: 150
            }
            WrapperRectangle {
                id: container

                margin: 8
                radius: Theme.borderRadius
                border.width: Theme.borderWidth
                border.color: Theme.accent
                color: Theme.background

                ColumnLayout {
                    RowLayout {
                        spacing: 8
                        ColumnLayout {
                            spacing: 4
                            ClippingRectangle {
                                Layout.alignment: Qt.AlignHCenter
                                radius: Theme.borderRadius
                                implicitHeight: infoColumn.implicitHeight
                                implicitWidth: infoColumn.implicitHeight
                                Image {
                                    source: UserInfo.face
                                    sourceSize.width: infoColumn.implicitHeight
                                }
                            }
                        }
                        ColumnLayout {
                            id: infoColumn
                            Layout.alignment: Qt.AlignTop
                            Text {
                                text: "  user:   " + UserInfo.username // Nerd Icons, nf-fa-user
                                color: Theme.text
                                font.family: Theme.fontFamily
                                font.pointSize: Theme.fontSize
                            }
                            Text {
                                text: "  host:   " + UserInfo.hostname // Nerd Icons, nf-fa-terminal
                                color: Theme.text
                                font.family: Theme.fontFamily
                                font.pointSize: Theme.fontSize
                            }
                            Text {
                                visible: UserInfo.cpuModel != ""
                                text: "  cpu:    " + UserInfo.cpuModel // Nerd Icons, nf-oct-cpu
                                color: Theme.text
                                font.family: Theme.fontFamily
                                font.pointSize: Theme.fontSize
                            }
                            RowLayout {
                                visible: UserInfo.gpuModels != ""
                                spacing: 0
                                Text {
                                    Layout.alignment: Qt.AlignTop
                                    text: "󰍹  gpu(s): " // Nerd Icons, nf-md-monitor
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                }
                                Text {
                                    Layout.alignment: Qt.AlignTop
                                    text: UserInfo.gpuModels
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                }
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        ClickableContainer {
                            id: button1
                            onClicked: poweroffProc.running = true
                            RowLayout {
                                Text {
                                    text: "" // Nerd Icons, nf-fa-power_off
                                    color: Theme.error
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                    width: height
                                }
                                Text {
                                    text: "power off"
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                    width: height
                                }
                            }
                        }
                        ClickableContainer {
                            id: button2
                            onClicked: rebootProc.running = true
                            RowLayout {
                                Text {
                                    text: "" // Nerd Icons, nf-fa-repeat
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                }
                                Text {
                                    text: "reboot"
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                    width: height
                                }
                            }
                        }
                        ClickableContainer {
                            id: button3
                            onClicked: lockProc.running = true
                            RowLayout {
                                Text {
                                    text: "" // Nerd Icons, nf-fa-lock
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                }
                                Text {
                                    text: "lock"
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                    width: height
                                }
                            }
                        }
                        Rectangle {
                            implicitWidth: 2
                            radius: 100
                            Layout.fillHeight: true
                            color: Theme.brightSurface
                        }
                        ClickableContainer {
                            Layout.fillWidth: true
                            onClicked: {
                                root.closeWindow();
                                displaysProc.running = true;
                            }
                            Text {
                                text: "󰍹 " // Nerd Icons, nf-md-monitor
                                color: Theme.text
                                font.family: Theme.fontFamily
                                font.pointSize: Theme.fontSize
                                horizontalAlignment: Qt.AlignHCenter
                            }
                        }
                        ClickableContainer {
                            Layout.fillWidth: true
                            onClicked: {
                                root.closeWindow();
                                Quickshell.execDetached(["quickshell", "-p", Quickshell.shellDir + "/CustomizationWindow.qml"]);
                            }
                            Text {
                                text: " " // Nerd Icons, nf-fa-paint_brush
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

    Process {
        id: poweroffProc
        command: ["shutdown", "-h", "now"]
    }

    Process {
        id: rebootProc
        command: ["reboot"]
    }

    Process {
        id: lockProc
        command: ["hyprctl", "dispatch", "exit"]
    }

    Process {
        id: displaysProc
        command: ["nwg-displays"]
    }
}
