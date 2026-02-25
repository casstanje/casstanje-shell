pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    property string homeFolder

    Process {
        command: ["bash", Quickshell.shellDir + "/scripts/getHomeFolder.sh"]
        stdout: StdioCollector {
            onStreamFinished: root.homeFolder = this.text.replace("\n", "")
        }
        running: true
    }
}