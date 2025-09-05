import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import './../'
import './../elements/'

WrapperRectangle {
    id: root
    required property var barRoot
    topMargin: 7
    bottomMargin: topMargin
    color: "transparent"
    Layout.fillHeight: true
    Container {
        RowLayout {
            spacing: 4
            Repeater {
                model: SystemTray.items
                SysTrayIcon {
                    barRoot: root.barRoot
                }
            }
        }
    }
}