pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Effects
import "../"
import './../elements'

MouseArea {
    id: root
    required property SystemTrayItem modelData
    //Layout.fillHeight: true

    required property var barRoot
    property point menuPosition: [0,0]

    implicitWidth: Config.trayIconSize
    implicitHeight: Config.trayIconSize

    hoverEnabled: true
    property bool hoveredOver: false
    onEntered: hoveredOver = true
    onExited: hoveredOver = false
    cursorShape: Qt.PointingHandCursor

    property list<var> currentSubMenus: []

    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    onClicked: function(mouse){
        if(mouse.button == Qt.LeftButton){
            root.modelData.activate()
        }else if(mouse.button == Qt.MiddleButton){
            root.modelData.secondaryActivate()
        }else{
            root.menuPosition.x = root.parent.mapToItem(barRoot, root.x, root.y).x
            root.menuPosition.y = barRoot.implicitHeight
            menu.open()
        }
    }
    IconImage {
        id: trayIcon
        source: root.modelData.icon
        width: parent.implicitWidth
        height: parent.implicitHeight
        anchors.centerIn: parent
    }

    Tooltip {
        visible: root.hoveredOver && root.modelData.tooltipTitle != ""
        text: root.modelData.tooltipTitle + (root.modelData.tooltipDescription != ""  ? "\n" + root.modelData.tooltipDescription : "")
    }

    QsMenuAnchor {
        id: menuAnchor
        menu: root.modelData.menu
        anchor.window: QsWindow.window
        anchor.rect.x: root.menuPosition.x
        anchor.rect.y: root.menuPosition.y
    }

    QsMenuOpener {
        id: menuOpener
        menu: root.modelData.menu
    }

    Menu {
        id: menu
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        parent: root.barRoot
        x: root.menuPosition.x
        y: root.menuPosition.y
        popupType: Popup.Window
        background: Rectangle {
            color: Theme.background
            radius: Theme.borderRadius
            border.width: Theme.borderWidth
            border.color: Theme.accent
        }
        padding: 8
        implicitWidth: columnLayout.implicitWidth + padding * 2
        ColumnLayout {
            spacing: 4
            id: columnLayout
            Repeater {
                model: menuOpener.children
                Loader {
                    id: loader
                    required property QsMenuEntry modelData
                    property Component item: SysTrayMenuItem {
                        modelData: loader.modelData
                        minimumWidth: columnLayout.implicitWidth
                    }

                    property Component subMenuComp: SysTrayMenuSubMenuItem {
                        modelData: loader.modelData
                        minimumWidth: columnLayout.implicitWidth
                        onNewMenu: function(menu, parent){
                            var object = {menu: menu, parent: parent}
                            if(root.currentSubMenus.includes(object)) root.currentSubMenus.splice(root.currentSubMenus.indexOf(object), 1)
                            root.currentSubMenus.push(object)
                        }
                    }

                    property Component separator: SysTrayMenuSeparator{}

                    sourceComponent: modelData.hasChildren ? subMenuComp : (modelData.isSeparator ? separator : item)
                }
            }
        }
    }

    Repeater {
        id: subMenuRepeater
        model: root.currentSubMenus
        Item {
            id: subMenuRoot
            required property var modelData
            Component.onCompleted: {
                subMenu.open()
            }
            Menu {
                parent: subMenuRoot.modelData.parent
                id: subMenu
                popupType: Popup.Window
                background: Rectangle {
                    color: Theme.background
                    radius: Theme.borderRadius
                    border.width: Theme.borderWidth
                    border.color: Theme.accent
                }
                onClosed: {
                    root.currentSubMenus.splice(root.currentSubMenus.indexOf(subMenuRoot.modelData), 1)
                }
                x: -implicitWidth - 12
                y: 0
                padding: 8
                implicitWidth: subMenuColumnLayout.width + padding * 2
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                ColumnLayout {
                    id: subMenuColumnLayout
                    Repeater {
                        model: subMenuRoot.modelData.menu
                        Loader {
                            id: subMenuLoader
                            required property QsMenuEntry modelData
                            property Component item: SysTrayMenuItem {
                                modelData: subMenuLoader.modelData
                                minimumWidth: subMenuColumnLayout.implicitWidth
                            }

                            property Component subMenuComp: Component { // Just a list as the subsubmenu
                                WrapperRectangle {
                                    color: Theme.darkerBackground
                                    radius: Theme.borderRadius
                                    margin: Theme.containerPadding
                                    ColumnLayout {
                                        Text {
                                            text: subMenuLoader.modelData.text + ":"
                                            color: Theme.text
                                            font.family: Theme.fontFamily
                                            font.pointSize: Theme.fontSize
                                        }
                                        SysTrayMenuSeparator {}
                                        QsMenuOpener {
                                            id: subMenuOpener
                                            menu: subMenuLoader.modelData
                                        }
                                        Repeater {
                                            model: subMenuOpener.children
                                            Loader {
                                                id: subSubMenuLoader
                                                required property var modelData
                                                property Component item: SysTrayMenuItem {
                                                    modelData: subSubMenuLoader.modelData
                                                    minimumWidth: subMenuColumnLayout.implicitWidth - 4
                                                }

                                                property Component separator: SysTrayMenuSeparator {}

                                                sourceComponent: modelData.isSeparator ? separator : item
                                            }
                                        }
                                    }
                                }
                            }

                            property Component separator: SysTrayMenuSeparator{}
                            sourceComponent: subMenuLoader.modelData.hasChildren ? subMenuComp : (subMenuLoader.modelData.isSeparator ? separator : item)
                        }
                    }
                }
            }
        }
    }

}