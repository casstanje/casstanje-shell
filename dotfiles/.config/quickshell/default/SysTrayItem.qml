//thanks, end-4

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

MouseArea {
    id: root

    required property SystemTrayItem item
    property bool targetMenuOpen: false
    property var bar: root.QsWindow.window
    hoverEnabled: true

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 17
    implicitHeight: 17
    onClicked: (event) => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) menu.open();
            break;
        }
        event.accepted = true;
    }

    QsMenuAnchor {
        id: menu
        menu: root.item.menu
        anchor.window: root.bar
        anchor.rect.x: (root.parent.parent.x + root.x) // Add the position of the rowlayout and the positiong of this item inside of the rowlayout to get the desired menu position
        anchor.rect.y: root.y + root.bar.height
        anchor.rect.height: root.height
        anchor.rect.width: root.width
    }

    IconImage {
        id: trayIcon
        visible: true
        source: root.item.icon
        anchors.centerIn: parent
        width: parent.width * 1
        height: parent.height * 1
    }

}