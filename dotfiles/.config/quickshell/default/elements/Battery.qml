import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import './'
import './../'
import './../functions/'
import './../windows/'

ClippingRectangle {
    id: root
    required property var barRoot

    property bool powerProfilesExists: false
    property bool brightnessctlExists: false

    property bool showWindow: false
    property bool windowHoveredOver: false


    property var visualPercentage: UPower.displayDevice.percentage >= 0.99 ? 1 : UPower.displayDevice.percentage

    radius: Theme.borderRadius
    implicitHeight: batteryElement.implicitHeight
    implicitWidth: batteryElement.implicitWidth
    color: Config.showBatteryChargeOutline ? Theme.brightSurface : "transparent"
    
    Rectangle {
        anchors.left: root.left        
        anchors.top: root.top

        width: batteryElement.width * root.visualPercentage
        height: batteryElement.height

        color: Config.showBatteryChargeOutline ? (UPower.displayDevice.state == UPowerDeviceState.Discharging ? Theme.error : Theme.correct) : "transparent"
    }

    ClippingWrapperRectangle {
        id: batteryElement
        visible: UPower.displayDevice.isLaptopBattery && Config.showLaptopBattery
        radius: Theme.borderRadius
        margin: Config.showBatteryChargeOutline ? 1 : 0
        
        color: "transparent"
        ClickableContainer {
            id: button
            backgroundColor: Theme.background
            enabled: 
                (root.powerProfilesExists && Config.enablePowerProfileControl) || 
                    (root.brightnessctlExists && Config.enableBrightnessControl)
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                root.showWindow = true
                UIVars.closePopupFunctions.push(function():Boolean{
                    if(!hoveredOver && !root.windowHoveredOver){
                        root.showWindow = false
                        return true
                    }else return false
                })
            }

            Text {
                text: "bat. " + Math.round(root.visualPercentage * 100) + "%"
                color: Theme.text
                font.family: Theme.fontFamily
                font.pointSize: Theme.fontSize
            }
        }

        Tooltip {
            parent: button
            visible: button.hoveredOver
            property real timeToSeconds: (UPower.displayDevice.state == UPowerDeviceState.Discharging ? UPower.displayDevice.timeToEmpty : UPower.displayDevice.timeToFull)
            text: "time to " + (UPower.displayDevice.state == UPowerDeviceState.Discharging ? "empty: " : "full: ") + Math.round(timeToSeconds/60) + "min\nleft/right: open menu"
        }

        PowerMenu {
            visible: root.showWindow

            anchor {
                window: root.barRoot.window
                rect.x: 0
                rect.y: 0
            }

            onEnteredCallback: function() {
                root.windowHoveredOver = true
            }

            onExitedCallback: function() {
                root.windowHoveredOver = false
            }
        
            barRoot: root.barRoot
            button: root
        }

        // Needs some time before starting
        Process {
            id: checkIfPowerProfilesExistsProc
            command: ["bash", FileHelper.homeFolder + "/.config/quickshell/default/scripts/checkIfPowerProfilesExists.sh"]
            stdout: StdioCollector {
                onStreamFinished: {
                    var out = this.text.replace("\n", "")
                    root.powerProfilesExists = out == "true"
                }
            }
        }

        Timer {
            interval: 100
            running: true
            onTriggered: {
                checkIfPowerProfilesExistsProc.running = true
            }
        }
        // Needs some time before starting as well
        Process {
            id: checkIfBrightnessctlExistsProc
            command: ["bash", FileHelper.homeFolder + "/.config/quickshell/default/scripts/checkIfBrightnessctlExists.sh"]
            stdout: StdioCollector {
                onStreamFinished: {
                    var out = this.text.replace("\n", "")
                    root.brightnessctlExists = out == "true"
                }
            }
        }

        Timer {
            interval: 100
            running: true
            onTriggered: {
                checkIfBrightnessctlExistsProc.running = true
            } 
        }
    }

}
