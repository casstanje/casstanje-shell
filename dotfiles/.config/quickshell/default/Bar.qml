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

Scope {
    property bool powerProfileSwitching: false
    property string pathToCyclePowerScript: FileUtils.trimFileProtocol(`${Quickshell.shellPath("scripts")}/cycle-power-profile.sh`)
    property string pathToRamUsageScript: FileUtils.trimFileProtocol(`${Quickshell.shellPath("scripts")}/ram-usage.sh`)
    property string pathToCpuUsageScript: FileUtils.trimFileProtocol(`${Quickshell.shellPath("scripts")}/cpu-usage.sh`)
    property string ramUsage: ""
    property string cpuUsage: ""
    property bool notifDnd
    property int notifCount: 0
    id: root
    
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            property string currentPowerProfile: PowerProfile.toString(PowerProfiles.profile).toLowerCase()
            screen: modelData
            id: bar
            anchors {
                top: true
                left: true
                right: true
            } 
            color: "#1e1e2e"
            margins.left: 8
            margins.right: 8
            margins.top: 8
            property var node: Pipewire.defaultAudioSink
            PwObjectTracker {
                objects: [bar.node]
            }
            

            

            implicitHeight: 45
            Row {}
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: "#a6e3a1"
                border.width: 2
                radius: 4
                RowLayout {
                    anchors.fill: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 0
                    Item {
                        width: 8
                    }
                    PowerMenu {}
                    Item {
                        width: 8
                    }
                    ClickableContainer {
                        clickAction: function(){
                            if(!root.powerProfileSwitching) changePowerProfileProc.running = true
                        }
                        child: Text {
                            text: root.powerProfileSwitching ? "switching..." : ((bar.currentPowerProfile == "balanced" ? "  " : bar.currentPowerProfile == "performance" ? " " : " ") + bar.currentPowerProfile)
                            color: "#cdd6f4"
                            font.family: "JetBrainsMono"
                            font.bold: true
                            font.pointSize: 10
                        }
                    }
                    Item {
                        width: 8
                    }
                    Battery {}
                    Item {
                        width: 8
                    }
                    ClickableContainer {
                        child: Text {
                            text: `vol ${Math.round(bar.node.audio.volume * 100)}%`
                            color: "#cdd6f4"
                            font.family: "JetBrainsMono"
                            font.bold: true
                            font.pointSize: 10
                        }

                        wheelUpAction: function(){
                            bar.node.audio.volume += (bar.node.audio.volume + 0.05 > 1.50 ? 1.5 - bar.node.audio.volume : 0.05)
                        }

                        clickAction: function(){
                            launchPavuControl.running = true
                        }

                        wheelDownAction: function(){
                            bar.node.audio.volume -= (bar.node.audio.volume - 0.05 < 0.00 ? bar.node.audio.volume : 0.05)
                        }
                    }
                    Item {
                        width: 8
                    }
                    ClickableContainer {
                        child: Text {
                            text: `mem ${root.ramUsage}`
                            color: "#cdd6f4"
                            font.family: "JetBrainsMono"
                            font.bold: true
                            font.pointSize: 10
                        }

                        clickAction: function(){
                            launchPlasmaSystemMonitor.running = true
                        }
                    }
                    Item {
                        width: 8
                    }
                    ClickableContainer {
                        child: Text {
                            text: `cpu ${root.cpuUsage.replace("\n", "")}%`
                            color: "#cdd6f4"
                            font.family: "JetBrainsMono"
                            font.bold: true
                            font.pointSize: 10
                        }

                        clickAction: function(){
                            launchPlasmaSystemMonitor.running = true
                        }
                    }
                    MediaPlayer {
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    Item {
                        width: 8
                    }
                    Container  {
                        child: Text {
                            text: "🏳️‍🌈 🏳️‍⚧️"
                            color: "#cdd6f4"
                            font.family: "JetBrainsMono"
                            font.bold: true
                            font.pointSize: 10
                        }
                    }
                    Item {
                        width: 8
                    }
                    Container {
                        child: RowLayout {
                            spacing: 8
                            Repeater {
                                model: SystemTray.items
                                id: repeater
                                SysTrayItem {
                                    required property SystemTrayItem modelData
                                    item: modelData
                                    Layout.fillHeight: true
                                }
                            }
                        }
                    }
                    Item {
                        width: 8
                    }
                    ClickableContainer  {
                        child: Text {
                            text: root.notifDnd ? "󰂛" : (root.notifCount > 0 ? "󱅫" : "󰂚")
                            color: "#cdd6f4"
                            font.family: "JetBrainsMono"
                            font.bold: true
                            font.pointSize: 10
                        }
                        rightClickAction: function(){
                            toggleNotifDnd.running = true
                        }

                        clickAction: function(){
                            openNotifPanel.running = true
                        }
                    }
                    Item {
                        width: 8
                    }
                    Container  {
                        child: Text {
                            text: Time.time
                            color: "#cdd6f4"
                            font.family: "JetBrainsMono"
                            font.bold: true
                            font.pointSize: 10
                        }
                    }
                    Item {
                        width: 8
                    }
                }
            }
        }
    }

    Process {
        id: changePowerProfileProc
        command: [`${root.pathToCyclePowerScript}`]
        onRunningChanged: {
            root.powerProfileSwitching = !root.powerProfileSwitching
        }
    }

    Process {
        id: launchPavuControl
        command: ["pavucontrol"]
    }

    Process {
        id: launchPlasmaSystemMonitor
        command: ["plasma-systemmonitor"]
    }

    Process {
        id: getRamUsage
        command: [`${root.pathToRamUsageScript}`]
        stdout: StdioCollector {
            onStreamFinished: {
                root.ramUsage = this.text
            }
        }
        running: true
    }

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: getRamUsage.running = true
    }

    Process {
        id: getCpuUsage
        command: [`${root.pathToCpuUsageScript}`]
        stdout: StdioCollector {
            onStreamFinished: {
                root.cpuUsage = this.text
            }
        }
        running: true
    }

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: getCpuUsage.running = true
    }

    Process {
        id: getNotifCount
        command: ["swaync-client", "-c"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.notifCount = parseInt(this.text)
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: getNotifCount.running = true
    }

    Process {
        id: getNotifDnd
        command: ["swaync-client", "-D"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.notifDnd = (this.text == "true")
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: getNotifDnd.running = true
    }

    Process {
        id: toggleNotifDnd
        command: ["swaync-client", "-d"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.notifDnd = (this.text == "true")
            }
        }
    }

    Process {
        id: openNotifPanel
        command: ["swaync-client", "-op"]
    }
    
}

