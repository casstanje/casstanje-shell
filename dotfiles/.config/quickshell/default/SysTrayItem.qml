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
    property var subMenuHovered: false
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

        MouseArea {
            id: menuMouseArea
            hoverEnabled: true
            implicitHeight: menuContainer.implicitHeight
            implicitWidth: menuContainer.implicitWidth
            onExited: if(!root.subMenuHovered) root.targetMenuOpen = false
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
                                onExited: {itemHoveredOver = false}
                                implicitWidth: (itemColumnLayout.implicitWidth < columnLayout.implicitWidth ? columnLayout.implicitWidth : itemColumnLayout.implicitWidth)
                                implicitHeight: itemColumnLayout.implicitHeight
                                acceptedButtons: Qt.LeftButton
                                onClicked: {
                                    if(loader.modelData.hasChildren){
                                        showSubMenu = !showSubMenu
                                    }else{
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
                                                        Image {
                                                            source: loader.modelData.icon
                                                            sourceSize.height: 15
                                                            sourceSize.width: 15
                                                        }
                                                    }

                                                    sourceComponent: loader.modelData.buttonType != QsMenuButtonType.None ? check : actualIcon
                                                }
                                                
                                            }

                                            sourceComponent: loader.modelData.icon != "" || loader.modelData.buttonType != QsMenuButtonType.None ? icon : null
                                        }
                                        Text {
                                            id: itemText
                                            text: loader.modelData.text + (loader.modelData.hasChildren ? (itemMouseArea.showSubMenu ? " " : " ") : "")
                                            color:  (!itemMouseArea.itemHoveredOver || !loader.modelData.enabled ? "#cdd6f4" : "#45475a")
                                            font.family: "JetBrainsMono"
                                            font.bold: true
                                            font.pointSize: 10
                                        }
                                    }

                                    Loader {
                                        property Component subMenuList: Component {
                                            ClippingWrapperRectangle {
                                                implicitHeight: itemMouseArea.showSubMenu ? (subMenuColumn.implicitHeight + 8) : 0
                                                implicitWidth: subMenuColumn.implicitWidth
                                                color: "#11111b"
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
                                                                hoverEnabled: true
                                                                onEntered: itemHoveredOver = true
                                                                onExited: itemHoveredOver = false
                                                                implicitHeight: subMenuItemRow.implicitHeight
                                                                onClicked: {
                                                                    subMenuLoader.modelData.triggered()
                                                                }
                                                                implicitWidth: (subMenuItemRow.implicitWidth + 8 < columnLayout.implicitWidth) ? columnLayout.implicitWidth : subMenuItemRow.implicitWidth + 8
                                                                RowLayout {
                                                                    x: 4
                                                                    id: subMenuItemRow
                                                                    spacing: 4
                                                                    Loader {
                                                                        property Component icon: Component {
                                                                            Image {
                                                                                source: subMenuLoader.modelData.icon
                                                                                sourceSize.height: 15
                                                                                sourceSize.width: 15
                                                                            }
                                                                        }

                                                                        sourceComponent: subMenuLoader.modelData.icon != "" ? icon : null
                                                                    }
                                                                    Text {
                                                                        id: subMenuItemText
                                                                        text: subMenuLoader.modelData.text
                                                                        color:  (!subMenuMouseArea.itemHoveredOver || !subMenuLoader.modelData.enabled ? "#cdd6f4" : "#45475a")
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

                                        sourceComponent: loader.modelData.hasChildren ? subMenuList : null
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