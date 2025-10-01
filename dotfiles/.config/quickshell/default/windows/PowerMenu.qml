import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import './../'
import './../singletons/'
import './../elements/'

PopupWindow {
    id: root

    required property var barRoot
    required property var button
    property var onExitedCallback: function(){}
    property var onEnteredCallback: function(){}
    property real currentBrightness
    property int currentProfile: PowerProfile.toString(PowerProfiles.profile).toLowerCase()

    color: "transparent"

    implicitHeight: barRoot.window.screen.height
    implicitWidth: barRoot.window.screen.width

    mask: Region { item: mouseArea }
    ClippingRectangle {
        x: root.button.parent.mapToItem(root.barRoot, root.button.x, 0).x
        y: root.barRoot.implicitHeight

        implicitHeight: mouseArea.implicitHeight
        NumberAnimation on implicitHeight {
            from: 0; to: mouseArea.implicitHeight;
            duration: 150
            running: root.visible
        }
        implicitWidth: mouseArea.implicitWidth
        color: "transparent"
        WrapperMouseArea {
            id: mouseArea
            hoverEnabled: true

            onEntered: {
                root.onEnteredCallback()
            }

            onExited: {
                root.onExitedCallback()
            }
            
            WrapperRectangle {
                id: container

                margin: 8 
                radius: Theme.borderRadius
                color: Theme.background
                border.color: Theme.accent
                border.width: Theme.borderWidth

                ColumnLayout {
                    ColumnLayout{
                        id: powerProfileControl
                        visible: Config.enablePowerProfileControl && root.button.powerProfilesExists

                        Text {
                            text: "power profile"
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pointSize: Theme.fontSize
                        }
                        Container {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 300
                            topMargin: leftMargin
                            bottomMargin: topMargin
                            
                            ElementWheel {
                                id: powerProfileWheel
                                model: PowerProfiles.hasPerformanceProfile ? ["powersaver", "balanced", "perfomance"] : ["powersaver", "balanced"]
                                currentIndex: root.currentProfile
                                onCurrentIndexChanged: {
                                    PowerProfiles.profile = currentIndex
                                    newValue = PowerProfile.toString(PowerProfiles.profile).toLowerCase()
                                }
                            }
                        }
                    }

                    ColumnLayout{
                        id: brightnessControl
                        visible: Config.enableBrightnessControl && root.button.brightnessctlExists

                        Text {
                            text: "screen brightness"
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pointSize: Theme.fontSize
                        }
                        Container {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 300
                            topMargin: leftMargin
                            bottomMargin: topMargin

                            RowLayout {
                                Layout.fillWidth: true
                                Slider {
                                    id: brightnessSlider
                                    Layout.fillWidth: true
                                    from: 0.1
                                    to: 1
                                    value: root.currentBrightness
                                    onMoved: {
                                        root.currentBrightness = value
                                        setBrightnessProc.running = true
                                    }
                                    background: SliderBackground {}
                                    handle: SliderHandle {}
                                }
                                Text {
                                    property string percentage: Math.round(brightnessSlider.value * 100).toString()
                                    text: (percentage.length == 2 ? " " : (percentage.length == 1 ? "  " : "")) + percentage + "%"
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                }
                            }

                        }
                    }
                }
            }
        }
    }

    Process {
        id: getCurrentBrightnessProc
        command: ["bash", Quickshell.shellDir + "/scripts/getBrightnessValue.sh", Config.backlightDeviceName]
        stdout: StdioCollector {
            onStreamFinished: {
                var jsonObject = JSON.parse(this.text)
                root.currentBrightness = Number(jsonObject.currentbrightness) / Number(jsonObject.maxbrightness)
            }
        }
        running: brightnessControl.visible && root.visible
    }

    Process {
        id: setBrightnessProc
        command: ["brightnessctl", "-d", Config.backlightDeviceName, "s", Math.round(root.currentBrightness * 100) + "%"]
    }
    
}
