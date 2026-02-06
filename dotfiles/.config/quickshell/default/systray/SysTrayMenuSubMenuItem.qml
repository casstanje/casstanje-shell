pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
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

    signal newMenu(menu: var, parent: var)

    onClicked: {
        newMenu(subMenuOpener.children, root)
    }

    QsMenuOpener {
        id: subMenuOpener
        menu: root.modelData
    }

    WrapperRectangle {
        color: parent.hoveredOver ? Theme.surface : "transparent"
        radius: Theme.borderRadius
        RowLayout {
            Text {
                padding: 2
                Layout.minimumWidth: root.minimumWidth
                text: root.modelData != null ? root.modelData.text + " " : false /*nf-fa-caret_right*/
                color: Theme.text
                font.family: Theme.fontFamily
                font.pointSize: Theme.fontSize
            }
        }
    }
}