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
        command: ["bash", Quickshell.shellDir + "/scripts/getCpuModel.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.cpuModel = this.text.replace("\n", "")
            }
        }
        running: true
    }

    // Get GPU Model
    Process {
        command: ["bash", Quickshell.shellDir + "/scripts/getGpuNames.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.gpuModels = this.text.substring(0, this.text.lastIndexOf('\n'))
            }
        }
        running: true
    }

    IpcHandler {
        target: "userInfo"
        function mouseClicked(): void { root.mouseClicked = !root.mouseClicked }
    }
}