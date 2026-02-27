pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import './../'
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root
    required property var modelData
    required property string text
    property string newValue: root.modelData["value"] 
    spacing: 6
    ColumnLayout {
        spacing: 0
        Text {
            text: root.text
            color: Theme.text
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
            font.bold: true
        }
        Text {
            visible: root.modelData["description"] != ""
            text: root.modelData["description"]
            color: Theme.subtext
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
            Layout.maximumWidth: root.width
            wrapMode: Text.Wrap
            onLinkActivated: (link) => Qt.openUrlExternally(link)
            linkColor: Theme.accent
        }
    }

    Loader {
        id: loader
        
        
        property Component check: Component {
            WrapperMouseArea {
                id: control
                property bool checked: root.modelData["value"] == "true"
                onCheckedChanged: {
                    root.newValue = checked ? "true" : "false"
                }

                onClicked: {
                    checked = !checked
                }
                cursorShape: Qt.PointingHandCursor
                Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    x: 0
                    y: parent.height / 2 - height / 2
                    radius: Theme.borderRadius
                    color: Theme.surface
                    border.width: root.modelData["startValue"] != root.newValue ? 1 : 0
                    border.color: Theme.accent 

                    Rectangle {
                        width: 14
                        height: 14
                        x: 6
                        y: 6
                        radius: 2
                        color: Theme.accent
                        visible: control.checked
                    }
                }
            }
        }

        property Component inputField: Component {
            WrapperMouseArea {
                cursorShape: Qt.IBeamCursor
                WrapperRectangle {
                    Layout.fillWidth: true
                    radius: Theme.borderRadius
                    color: Theme.surface
                    border.width: root.modelData["startValue"] != root.newValue ? 1 : 0
                    border.color: Theme.accent 
                    TextInput {

                        padding: 8
                        text: root.modelData["value"]
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                        selectionColor: Theme.accent
                        selectedTextColor: Theme.background
                        onTextEdited: {
                            root.newValue = text
                        }
                        validator: RegularExpressionValidator {
                            regularExpression: 
                                root.modelData["type"] == "int" ? /^[0-9]{1,6}+/ :
                                /.*/
                        }
                    }
                }
            }
        }

        property Component systemClockWheel: Component {
            WrapperRectangle {
                color: "transparent"
                implicitWidth: 150
                border.width: root.modelData["startValue"] != root.newValue ? 1 : 0
                border.color: Theme.accent 
                ElementWheel {
                    Layout.fillWidth: true
                    items: ["seconds", "minutes", "hours"]
                    initialValue: Number(root.modelData["value"])
                }
            }
        }

        sourceComponent: root.modelData["type"] == "bool" ? check : (root.modelData["type"] == "SystemClock" ? systemClockWheel : inputField)
    }
}
