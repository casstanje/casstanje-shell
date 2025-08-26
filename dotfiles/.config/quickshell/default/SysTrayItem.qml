pragma ComponentBehavior: Bound
//thanks, end-4

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

MouseArea {
    id: root

    required property SystemTrayItem item
    property bool targetMenuOpen: false
    property var bar: root.QsWindow.window
    property var subMenuOpen: false
    property var subSubMenuOpen: false
    property var subMenuPosition
    property var subSubMenuPosition
    hoverEnabled: true

    Connections {
        target: root
    }

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 17
    implicitHeight: 17
    onClicked: (event) => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) targetMenuOpen = true;
            break;
        }
        event.accepted = true;
    }

    QsMenuOpener {
        id: menuOpener
        menu: root.item.menu
    }

    PopupWindow {
        visible: root.targetMenuOpen
        anchor.window: root.bar
        anchor.rect.x: (root.parent.parent.x + root.x) // Add the position of the rowlayout and the positiong of this item inside of the rowlayout to get the desired menu position
        anchor.rect.y: root.y + root.bar.height / 3
        anchor.rect.height: root.height
        anchor.rect.width: root.width
        implicitHeight: menuContainer.implicitHeight
        implicitWidth: menuContainer.implicitWidth
        color: "transparent"
        id: menuWindow

        MouseArea {
            id: menuMouseArea
            hoverEnabled: true
            implicitHeight: menuContainer.implicitHeight
            implicitWidth: menuContainer.implicitWidth
            property bool menuHovered
            onEntered: {
                menuHovered = true
            }
            onExited: {
                if(root.subMenuOpen != true) root.targetMenuOpen = false
                menuHovered = false
            }
            
            Rectangle {
                id: menuContainer
                color: "#1e1e2e"
                border.color: "#a6e3a1"
                border.width: 2
                radius: 4
                implicitHeight: columnLayout.implicitHeight + 16
                implicitWidth: Math.ceil(columnLayout.implicitWidth + 16, 250) 
                ColumnLayout {
                    id: columnLayout
                    x: 8
                    y: 8
                    Repeater {
                        model: menuOpener.children
                        Loader {
                            required property var modelData
                            id: loader
                            readonly property Component seperator: Rectangle {
                                implicitHeight: 2
                                implicitWidth: columnLayout.width
                                color: "transparent"
                            }

                            readonly property Component text: MouseArea{
                                id: itemMouseArea
                                hoverEnabled: true
                                property bool itemHoveredOver: false
                                property bool showSubMenu: false
                                onEntered: itemHoveredOver = true
                                onExited: {  itemHoveredOver = false }
                                implicitWidth: (itemColumnLayout.implicitWidth < columnLayout.implicitWidth ? columnLayout.implicitWidth : itemColumnLayout.implicitWidth)
                                implicitHeight: itemColumnLayout.implicitHeight
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: function(mouse) {
                                    if(loader.modelData.hasChildren){
                                        root.subMenuOpen = true
                                        root.subMenuPosition = mapToItem(menuMouseArea, mouse.x, mouse.y)
                                        showSubMenu = true
                                        
                                    }else if(mouse.button == Qt.LeftButton){
                                        loader.modelData.triggered()
                                    }
                                }

                                ColumnLayout {
                                    id: itemColumnLayout
                                    RowLayout {
                                        id: itemRow
                                        spacing: 4
                                        Loader {
                                            property Component icon: Component {
                                                Loader {
                                                    readonly property Component check: Component {
                                                        Text {
                                                            text: (loader.modelData.checkState == Qt.Unchecked ? "󰄱" : "󰱒")
                                                            color: (!itemMouseArea.itemHoveredOver || !loader.modelData.enabled ? "#cdd6f4" : "#45475a")
                                                            font.family: "JetBrainsMono"
                                                            font.bold: true
                                                            font.pointSize: 10
                                                        }
                                                    }

                                                    readonly property Component actualIcon: Component {
                                                        IconImage {
                                                            source: loader.modelData.icon
                                                            implicitHeight: 15
                                                            implicitWidth: 15
                                                        }
                                                    }

                                                    sourceComponent: loader.modelData.buttonType != QsMenuButtonType.None ? check : actualIcon
                                                }
                                                
                                            }

                                            sourceComponent: loader.modelData.icon != "" || loader.modelData.buttonType != QsMenuButtonType.None ? icon : null
                                        }
                                        Text {
                                            id: itemText
                                            text: loader.modelData.text + (loader.modelData.hasChildren ? " 󰇘" : "")
                                            color:  (!itemMouseArea.itemHoveredOver || !loader.modelData.enabled ? "#cdd6f4" : "#45475a")
                                            font.family: "JetBrainsMono"
                                            font.bold: true
                                            font.pointSize: 10
                                        }
                                    }

                                    PopupWindow {
                                        anchor.window: root.bar
                                        anchor.rect.x: root.subMenuPosition.x + root.x + root.parent.parent.x - 8
                                        anchor.rect.y: root.subMenuPosition.y + root.y + root.bar.height / 3 - 8
                                        anchor.rect.height: root.height
                                        anchor.rect.width: root.width
                                        implicitWidth: subMenuContainer.implicitWidth
                                        implicitHeight: subMenuContainer.implicitHeight
                                        color: "transparent"
                                        visible: itemMouseArea.showSubMenu

                                        MouseArea {
                                            hoverEnabled: true
                                            property var closeSubMenu: function(newMouseX, newMouseY) {
                                                itemMouseArea.showSubMenu = false
                                                root.subMenuOpen = false
                                                var actualMousePos = mapToItem(menuMouseArea, newMouseX != null ? newMouseX : mouseX, newMouseY != null ? newMouseY : mouseY)
                                                if(actualMousePos.x < 0 || actualMousePos.x > menuMouseArea.implicitWidth || actualMousePos.y < 0 || actualMousePos.y > menuMouseArea.implicitHeight) root.targetMenuOpen = false
                                            }
                                            onExited: {
                                                if(!root.subSubMenuOpen){
                                                    closeSubMenu()
                                                }
                                            }
                                            implicitWidth: subMenuContainer.implicitWidth
                                            implicitHeight: subMenuContainer.implicitHeight
                                            property bool showSubSubMenu: false
                                            id: subMenuRoot
                                            Rectangle {
                                                id: subMenuContainer
                                                implicitWidth: subMenuColumn.implicitWidth
                                                implicitHeight: subMenuColumn.implicitHeight
                                                color: "#1e1e2e"
                                                border.color: "#a6e3a1"
                                                border.width: 2
                                                radius: 4
                                                ColumnLayout {
                                                    id: subMenuColumn
                                                    spacing: 4
                                                    Rectangle {
                                                        implicitHeight: 0
                                                    }
                                                    Repeater {
                                                        model: subMenuOpener.children
                                                        Loader {
                                                            required property var modelData
                                                            id: subMenuLoader

                                                            readonly property Component seperator: Rectangle {
                                                                implicitHeight: 2
                                                                implicitWidth: subMenuColumn.width
                                                                color: "transparent"
                                                            }

                                                            readonly property Component text: MouseArea {
                                                                id: subMenuMouseArea
                                                                
                                                                property bool itemHoveredOver: false
                                                                property bool showSubSubMenu: false
                                                                hoverEnabled: true
                                                                onEntered: itemHoveredOver = true
                                                                onExited: itemHoveredOver = false
                                                                implicitHeight: subMenuItemRow.implicitHeight
                                                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                                                onClicked: function(mouse) {
                                                                    if(subMenuLoader.modelData.hasChildren){
                                                                        root.subSubMenuOpen = true
                                                                        root.subSubMenuPosition = mapToItem(menuMouseArea, mouse.x, mouse.y)
                                                                        showSubSubMenu = true
                                                                    }else if(mouse.button == Qt.LeftButton){
                                                                        subMenuLoader.modelData.triggered()
                                                                    }
                                                                }
                                                                implicitWidth: (subMenuItemRow.implicitWidth + 8 < subMenuColumn.implicitWidth) ? subMenuColumn.implicitWidth : subMenuItemRow.implicitWidth + 8
                                                                RowLayout {
                                                                    x: 4
                                                                    id: subMenuItemRow
                                                                    spacing: 4
                                                                    Loader {
                                                                        property Component icon: Component {
                                                                            Loader {
                                                                                readonly property Component check: Component {
                                                                                    Text {
                                                                                        text: (subMenuLoader.modelData.checkState == Qt.Unchecked ? "󰄱" : "󰱒")
                                                                                        color: (!subMenuMouseArea.itemHoveredOver || !subMenuLoader.modelData.enabled ? "#cdd6f4" : "#45475a")
                                                                                        font.family: "JetBrainsMono"
                                                                                        font.bold: true
                                                                                        font.pointSize: 10
                                                                                    }
                                                                                }

                                                                                readonly property Component actualIcon: Component {
                                                                                    IconImage {
                                                                                        source: subMenuLoader.modelData.icon
                                                                                        implicitHeight: 15
                                                                                        implicitWidth: 15
                                                                                    }
                                                                                }

                                                                                sourceComponent: subMenuLoader.modelData.buttonType != QsMenuButtonType.None ? check : actualIcon
                                                                            }
                                                                        }

                                                                        sourceComponent: subMenuLoader.modelData.icon != "" || subMenuLoader.modelData.buttonType != QsMenuButtonType.None ? icon : null
                                                                    }
                                                                    Text {
                                                                        id: subMenuItemText
                                                                        text: subMenuLoader.modelData.text + (subMenuLoader.modelData.hasChildren ? " 󰇘" : "")
                                                                        color:  (!subMenuMouseArea.itemHoveredOver || !subMenuLoader.modelData.enabled ? "#cdd6f4" : "#45475a")
                                                                        font.family: "JetBrainsMono"
                                                                        font.bold: true
                                                                        font.pointSize: 10
                                                                    }
                                                                }

                                                                QsMenuOpener {
                                                                    id: subSubMenuOpener
                                                                    menu: subMenuLoader.modelData
                                                                }

                                                                

                                                                PopupWindow {
                                                                    anchor.window: root.bar
                                                                    anchor.rect.x: root.subSubMenuPosition.x + root.x + root.parent.parent.x - 8
                                                                    anchor.rect.y: root.subSubMenuPosition.y + root.y + root.bar.height / 3 - 8
                                                                    anchor.rect.height: root.height
                                                                    anchor.rect.width: root.width
                                                                    implicitWidth: subSubMenuPosition.implicitWidth
                                                                    implicitHeight: subSubMenuPosition.implicitHeight
                                                                    color: "transparent"
                                                                    visible: subMenuMouseArea.showSubSubMenu

                                                                    MouseArea {
                                                                        hoverEnabled: true
                                                                        onExited: {
                                                                            subMenuMouseArea.showSubSubMenu = false
                                                                            root.subSubMenuOpen = false
                                                                            var actualMousePos = mapToItem(subMenuRoot, mouseX, mouseY)
                                                                            if(actualMousePos.x < 0 || actualMousePos.x > subMenuRoot.implicitWidth || actualMousePos.y < 0 || actualMousePos.y > subMenuRoot.implicitHeight) subMenuRoot.closeSubMenu(mouseX, mouseY)
                                                                        }
                                                                        implicitWidth: subSubMenuPosition.implicitWidth
                                                                        implicitHeight: subSubMenuPosition.implicitHeight
                                                                        Rectangle {
                                                                            id: subSubMenuPosition
                                                                            implicitWidth: subSubMenuColumn.implicitWidth
                                                                            implicitHeight: subSubMenuColumn.implicitHeight
                                                                            color: "#1e1e2e"
                                                                            border.color: "#a6e3a1"
                                                                            border.width: 2
                                                                            radius: 4
                                                                            ColumnLayout {
                                                                                id: subSubMenuColumn
                                                                                spacing: 4
                                                                                Rectangle {
                                                                                    implicitHeight: 0
                                                                                }
                                                                                Repeater {
                                                                                    model: subSubMenuOpener.children
                                                                                    Loader {
                                                                                        required property var modelData
                                                                                        id: subSubMenuLoader

                                                                                        readonly property Component seperator: Rectangle {
                                                                                            implicitHeight: 2
                                                                                            implicitWidth: subMenuColumn.width
                                                                                            color: "transparent"
                                                                                        }

                                                                                        readonly property Component text: MouseArea {
                                                                                            id: subSubMenuMouseArea
                                                                                            
                                                                                            property bool itemHoveredOver: false
                                                                                            hoverEnabled: true
                                                                                            onEntered: itemHoveredOver = true
                                                                                            onExited: itemHoveredOver = false
                                                                                            implicitHeight: subSubMenuItemRow.implicitHeight
                                                                                            onClicked: {
                                                                                                subSubMenuLoader.modelData.triggered()
                                                                                            }
                                                                                            implicitWidth: (subSubMenuItemRow.implicitWidth + 8 < subSubMenuColumn.implicitWidth) ? subSubMenuColumn.implicitWidth : subSubMenuItemRow.implicitWidth + 8
                                                                                            RowLayout {
                                                                                                x: 4
                                                                                                id: subSubMenuItemRow
                                                                                                spacing: 4
                                                                                                Loader {
                                                                                                    property Component icon: Component {
                                                                                                        Loader {
                                                                                                            readonly property Component check: Component {
                                                                                                                Text {
                                                                                                                    text: (subSubMenuLoader.modelData.checkState == Qt.Unchecked ? "󰄱" : "󰱒")
                                                                                                                    color: (!subSubMenuMouseArea.itemHoveredOver || !subSubMenuLoader.modelData.enabled ? "#cdd6f4" : "#45475a")
                                                                                                                    font.family: "JetBrainsMono"
                                                                                                                    font.bold: true
                                                                                                                    font.pointSize: 10
                                                                                                                }
                                                                                                            }

                                                                                                            readonly property Component actualIcon: Component {
                                                                                                                IconImage {
                                                                                                                    source: subSubMenuLoader.modelData.icon
                                                                                                                    implicitHeight: 15
                                                                                                                    implicitWidth: 15
                                                                                                                }
                                                                                                            }

                                                                                                            sourceComponent: subSubMenuLoader.modelData.buttonType != QsMenuButtonType.None ? check : actualIcon
                                                                                                        }
                                                                                                    }

                                                                                                    sourceComponent: subSubMenuLoader.modelData.icon != "" || subSubMenuLoader.modelData.buttonType != QsMenuButtonType.None ? icon : null
                                                                                                }
                                                                                                Text {
                                                                                                    id: subSubMenuItemText
                                                                                                    text: subSubMenuLoader.modelData.text
                                                                                                    color:  (!subSubMenuMouseArea.itemHoveredOver || !subSubMenuLoader.modelData.enabled ? "#cdd6f4" : "#45475a")
                                                                                                    font.family: "JetBrainsMono"
                                                                                                    font.bold: true
                                                                                                    font.pointSize: 10
                                                                                                }
                                                                                            }
                                                                                        }

                                                                                        sourceComponent: modelData.isSeparator ? seperator : text
                                                                                    }
                                                                                    
                                                                                }
                                                                                Rectangle {
                                                                                    implicitHeight: 0
                                                                                }
                                                                            }
                                                                        }
                                                                    }

                                                                }
                                                            }

                                                            sourceComponent: modelData.isSeparator ? seperator : text

                                                            
                                                        }
                                                        
                                                    }
                                                    Rectangle {
                                                        implicitHeight: 0
                                                    }
                                                }
                                            }
                                        }

                                    }
                                }
                                

                                QsMenuOpener {
                                    id: subMenuOpener
                                    menu: loader.modelData
                                }
                            }

                            sourceComponent: modelData.isSeparator ? seperator : text
                        }
                        
                    }

                }
            }
        }
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
