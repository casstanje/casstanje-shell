import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import '../'

Repeater {
    id: workspaces
    model: Config.workspacesEnabled ? Hyprland.workspaces : undefined
    visible: Config.workspacesEnabled
    Container {
        id: workspace
        required property var modelData
        border.color: modelData.focused ? Theme.accent : (workspace.modelData.active ? Theme.surface : Theme.surface)
        color: workspaceMouseArea.isHovered ? Theme.brightSurface : "transparent"
        property var toplevels: Hyprland.workspaces
        onToplevelsChanged: {
            topLevelHolder.filterWindows()
        }

        WrapperMouseArea {
            id: workspaceMouseArea

            hoverEnabled: true
            property bool isHovered: false

            onEntered: isHovered = true
            onExited: isHovered = false

            cursorShape: Qt.PointingHandCursor

            onClicked: {
                workspace.modelData.activate()
            }

            ColumnLayout {
                spacing: 0
            
                RowLayout {
                    id: topLevelHolder
                    property int missingIcons: 0
                    spacing: Theme.listSpacing
                    ListModel {id: windowIcons}
                    property var toplevels: workspace.modelData.toplevels.values
                    onToplevelsChanged: {
                        filterWindowsTimer.running = true
                    }

                    Timer {
                        // Neccesary to allow quickshell enough time to load window data
                        id: filterWindowsTimer
                        running: false
                        repeat: false
                        interval: 100
                        onTriggered: {
                            topLevelHolder.filterWindows()
                        }
                    }
                    

                    Text {
                        font.pointSize: Theme.fontSize
                        text: workspace.modelData.id + (windowIcons.count > 0 || topLevelHolder.missingIcons > 0 ? ":" : "")
                        color: Theme.text
                    }

                    function filterWindows(){
                        missingIcons = 0
                        windowIcons.clear()
                        if(Config.showOnlyIds) return
                        for(var windowIndex in topLevelHolder.toplevels){
                            var window = toplevels[windowIndex]
                            if(window.address == ""){
                                return
                            }
                            var stringId = window.wayland.appId
                            var iconPath = Quickshell.iconPath(stringId, true)
                            if(iconPath != "" && windowIcons.count < 2){
                                windowIcons.append({"icon": iconPath})
                            } else {
                                missingIcons++
                            }
                        }
                    }

                    Component.onCompleted: {
                        filterWindows()
                    }

                    Repeater {
                        model: windowIcons
                        WrapperRectangle {
                            required property var modelData
                            color: "transparent"
                            implicitHeight: visible ? 13 : 0
                            implicitWidth: implicitHeight
                            IconImage {
                                source: parent.modelData
                            }
                        }
                    }

                    Text {
                        visible: topLevelHolder.missingIcons > 0
                        text: "+" + topLevelHolder.missingIcons
                        color: Theme.text
                        font.pointSize: Theme.fontSize
                    }
                }
            }
        }

    }
}