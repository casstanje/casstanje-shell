pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import './../'
WrapperMouseArea {
    id: root
    required property QsMenuEntry modelData
    property real minimumWidth: 200
    hoverEnabled: true
    property bool hoveredOver: false
    onEntered: hoveredOver = true
    onExited: hoveredOver = false

    cursorShape: Qt.PointingHandCursor

    onClicked: {
        root.modelData.triggered()
    }
    WrapperRectangle {
        color: parent.hoveredOver ? Theme.surface : "transparent"
        radius: Theme.borderRadius
        RowLayout {
            spacing: 6
            Loader {
                visible: root.modelData != null ? root.modelData.buttonType != QsMenuButtonType.None || root.modelData.icon != "" : false

                id: iconLoader
                property Component check: Component {
                    Text {
                        padding: 2
                        text: root.modelData.checkState == 
                            Qt.PartiallyChecked ? "" /*nf-fa-minus_square_o*/ : 
                                (root.modelData.checkState == Qt.Checked ? 
                                    "" /*nf-fa-check_square_o*/ : 
                                        "" /*nf-fa-square_o*/)
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize
                    }
                }

                property Component icon: Component {
                    WrapperRectangle {
                        margin: 2
                        color: "transparent"
                        IconImage {
                            source: root.modelData.icon
                            implicitSize: 15
                        }
                    }
                }

                property Component empty : Component {
                    Text {
                        text: ""
                    }
                }

                sourceComponent: root.modelData == null ? empty : root.modelData.buttonType == QsMenuButtonType.None ? icon : check
            }
            Text {
                padding: 2
                Layout.minimumWidth: root.minimumWidth - (parent.width - width)
                text: root.modelData != null ? root.modelData.text : ""
                color: Theme.text
                font.family: Theme.fontFamily
                font.pointSize: Theme.fontSize
            }
        }
    }
}