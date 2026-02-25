pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import "./../"
import "./../singletons"
import "./../elements"

PopupWindow {
    id: root
    property var container: container
    property var button
    property var barRoot
    mask: Region { item: mouseArea }
    implicitWidth: barRoot.window.screen.width
    implicitHeight: barRoot.window.screen.height
    color: "transparent"
    property var usableNodes: function(){
        var newList = []
        for(var i = 0; i < Pipewire.nodes.values.length; i++){
            var node = Pipewire.nodes.values[i]
            if(node.audio != null && node.isSink && !node.isStream){ // Checks that the node is actual hardware that supports audio output
                newList.push(node)
            }
        }
        return newList
    }

    HyprlandFocusGrab {
        id: grab
        windows: [ root ]
        onCleared: {
            root.visible = false;
        }
    }

    PwObjectTracker {
        objects: root.usableNodes()
    }

    ClippingRectangle {
        id: parentContainer
        x: root.button.parent.mapToItem(root.barRoot, root.button.x, 0).x
        y: root.barRoot.implicitHeight
        implicitHeight: mouseArea.implicitHeight
        SequentialAnimation {
            id: spawnAnim
            running: root.visible
            NumberAnimation {
                target: parentContainer
                property: "implicitHeight"
                from: 0; to: container.implicitHeight
                duration: 150
            }
            ScriptAction {
                script: {
                    grab.active = true;
                }
            }
        }
        implicitWidth: mouseArea.implicitWidth
        color: "transparent"
        WrapperMouseArea {
            id: mouseArea
            hoverEnabled: true

            WrapperRectangle {
                id: container

                margin: 8
                radius: Theme.borderRadius
                border.width: Theme.borderWidth
                border.color: Theme.accent
                color: Theme.background

                ColumnLayout {
                    id: nodeColumn
                    Repeater {
                        model: root.usableNodes()
                        ColumnLayout {
                            id: nodeItem
                            required property var modelData
                            property bool isActive: Pipewire.defaultAudioSink != null ? Pipewire.defaultAudioSink.id == modelData.id : false
                            RowLayout {
                                spacing: 0
                                Text {
                                    text: nodeItem.modelData.description == "" ? nodeItem.modelData.name : nodeItem.modelData.description
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.rightMargin: 12
                                }
                                RowLayout {
                                    spacing: 6
                                    ClickableContainer {
                                        id: muteButton
                                        onClicked: {
                                            nodeItem.modelData.audio.muted = !nodeItem.modelData.audio.muted
                                        }
                                        Text {
                                            text: "" /*nf-fa-volume_xmark*/
                                            color: nodeItem.modelData.audio.muted ? Theme.error : Theme.brightSurface
                                            font.family: Theme.fontFamily
                                            font.pointSize: Theme.fontSize
                                        }
                                    }
                                    WrapperMouseArea {
                                        id: nodeMouseArea

                                        hoverEnabled: true
                                        property bool isHovered: false
                                        onEntered: isHovered = true
                                        onExited: isHovered = false

                                        cursorShape: nodeItem.isActive ? Qt.ArrowCursor : Qt.PointingHandCursor

                                        onClicked: {
                                            Pipewire.preferredDefaultAudioSink = nodeItem.modelData
                                        }

                                        WrapperRectangle {
                                            margin: 4
                                            radius: Theme.borderRadius
                                            color: nodeItem.isActive ? Theme.correct : (nodeMouseArea.isHovered ? Theme.surface : "transparent")
                                            border.color: nodeItem.isActive ? "transparent" : Theme.brightSurface
                                            border.width: 1
                                            Text {
                                                text: nodeItem.isActive ? "active" : "inactive"
                                                color: nodeItem.isActive ? Theme.background : Theme.text
                                                font.family: Theme.fontFamily
                                                font.pointSize: Theme.fontSize
                                            }
                                        }
                                    }
                                }
                            }
                            RowLayout {
                                implicitWidth: 300 < nodeColumn.implicitWidth ? nodeColumn.implicitWidth : 300
                                Slider {
                                    id: volumeSlider
                                    from: 0
                                    to: 1
                                    value: nodeItem.modelData.audio.volume
                                    onValueChanged: {
                                        if(nodeItem.modelData.audio.bound) {
                                            nodeItem.modelData.audio.volume = volumeSlider.value
                                        }
                                    }
                                    Layout.fillWidth: true
                                    background: SliderBackground {}

                                    handle: SliderHandle {}
                                }
                                Text {
                                    property string percentage: Math.round(volumeSlider.value * 100).toString()
                                    text: (percentage.length == 2 ? " " : (percentage.length == 1 ? "  " : "")) + percentage + "%"
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                }
                            }
                        }
                    }

                    ClickableContainer {
                        onClicked: {
                            pavucontrolProc.running = true
                        }
                        Layout.fillWidth: true
                        Text {
                            text: "open pavucontrol-qt"
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

    Process {
        id: pavucontrolProc
        command: ["pavucontrol-qt"]
    }
}