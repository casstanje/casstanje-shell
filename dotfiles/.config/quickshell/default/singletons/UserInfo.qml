pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string face: "false"
    property string username: ""
    property string hostname: ""
    property string cpuModel: ""
    property string gpuModels: ""
    property string cpuUsage: ""
    property string memoryUsage: ""
    property bool mouseClicked: false

    // Get User Image
    Process {
        command: ["bash", Quickshell.shellDir + "/scripts/checkIfFaceExists.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.face = this.text.replace("\n", "")
            } 
        }
        running: true
    }

    // Get Username
    Process {
        command: ["whoami"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.username = this.text.replace("\n", "")
            }
        }
        running: true
    }

    // Get Hostname
    Process {
        command: ["hostname"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.hostname = this.text.replace("\n", "")
            }
        }
        running: true
    }

    // Get CPU Model
    Process {
        command: ["fastfetch", "--format", "json", "-s", "CPU"]
        stdout: StdioCollector {
            onStreamFinished: {
                var jsonData = JSON.parse(this.text)
                root.cpuModel = jsonData[0].result.cpu
            }
        }
        running: true
    }

    // Get GPU Model
    Process {
        command: ["fastfetch", "--format", "json", "-s", "GPU"]
        stdout: StdioCollector {
            onStreamFinished: {
                var jsonData = JSON.parse(this.text)[0].result
                var newString = ""
                for(var i = 0; i < jsonData.length; i++){
                    newString += jsonData[i].name + (i != jsonData.length - 1 ? "\n" : "")
                }
                root.gpuModels = newString
            }
        }
        running: true
    }


    // Get Usage Info
    Process {
        id: usageInfoProc
        command: ["fastfetch", "--format", "json", "-s", "CPUUsage:Memory"]
        stdout: StdioCollector {
            onStreamFinished: {
                var jsonData = JSON.parse(this.text)
                var cpuUsageResult = jsonData[0].result
                var memoryResult = jsonData[1].result

                var totalUsage = 0
                for (var i = 0; i < cpuUsageResult.length; i++){
                    totalUsage += cpuUsageResult[i]
                }
                root.cpuUsage = Math.round(totalUsage / (cpuUsageResult.length - 1)).toString() + "%"

                root.memoryUsage = Math.round((memoryResult.used / memoryResult.total) * 100).toString() + "%"
            }
        }
        running: true
    }

    Timer {
        interval: 2500
        running: true
        repeat: true
        onTriggered: {
            usageInfoProc.running = true
        }
    }
}