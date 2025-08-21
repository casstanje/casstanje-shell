import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Io

ClippingWrapperRectangle{
    id: wrapper
    implicitHeight: 25
    implicitWidth: state == "NORMAL" ? powerButton.implicitWidth : row.implicitWidth
    color: "transparent"
    state: "NORMAL"

    Behavior on implicitWidth { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

    MouseArea { 
        implicitWidth: wrapper.implicitWidth   
        implicitHeight: 25
        hoverEnabled: true
        onEntered: wrapper.state = "EXPANDED"
        onExited: wrapper.state = "NORMAL"
        RowLayout {
            spacing: 8
            id: row
            ClickableContainer {
                id: powerButton
                Text {
                    text: "⏻"
                    color: "#cdd6f4"
                    font.family: "JetBrainsMono"
                    font.bold: true
                    font.pointSize: 10
                }
                clickAction: function(){
                    poweroffProc.running = true
                }
            }
            ClickableContainer {
                id: rebootButton
                Text {
                    text: "󰜉"
                    color: "#cdd6f4"
                    font.family: "JetBrainsMono"
                    font.bold: true
                    font.pointSize: 10
                }
                clickAction: function(){
                    rebootProc.running = true
                }
            }
            ClickableContainer {
                id: logoutButton
                Text {
                    text: "󰩈"
                    color: "#cdd6f4"
                    font.family: "JetBrainsMono"
                    font.bold: true
                    font.pointSize: 10
                }
                clickAction: function(){
                    exitProc.running = true
                }
            }
        }
    }

    Process {
        id: rebootProc
        command: ["reboot"]
    }

    Process {
        id: exitProc
        command: ["hyprctl", "dispatch", "exit"]
    }

    Process {
        id: poweroffProc
        command: ["shutdown", "-h", "now"]
    }
}
