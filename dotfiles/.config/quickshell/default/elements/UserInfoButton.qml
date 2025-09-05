pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "./../"
import "./../functions"
import "./../windows"

WrapperMouseArea {
    id: root

    required property Item barRoot

    hoverEnabled: true
    property bool hoveredOver: false
    onEntered: hoveredOver = true
    onExited: hoveredOver = false

    cursorShape: Qt.PointingHandCursor

    acceptedButtons: Qt.LeftButton | Qt.RightButton

    property bool showWindow: false
    property point windowLocation: [0, 0]
    property bool mouseInPopup: false

    onClicked: function(mouse){
        root.windowLocation = root.parent.mapToItem(root.barRoot, root.x, root.y)
        showWindow = true
        UIVars.closePopupFunctions.push(function():Boolean{ 
            if(!root.mouseInPopup && !root.hoveredOver){
                root.showWindow = false
                return true
            }else return false
        })
    }

    UserInfoWindow {
        visible: root.showWindow
        closeWindow: function() { root.showWindow = false }
        onExitedCallback: function() {
            root.mouseInPopup = false
        }
        onEnteredCallback: function() {
            root.mouseInPopup = true
        }
        anchor {
            window: root.barRoot.window
            rect.x: 0
            rect.y: 0
        }
        barRoot: root.barRoot
        button: root
    }

    WrapperRectangle {    
        margin: Theme.containerPadding
        leftMargin: Theme.containerPadding * 2
        rightMargin: Theme.containerPadding * 2

        border.width: Theme.smallBorderWidth
        border.color: Theme.surface
        color: root.hoveredOver ? Theme.brightSurface : "transparent"
        radius: Theme.borderRadius

        RowLayout {
            spacing: 8
            Loader {
                property var image: Component {
                    ClippingWrapperRectangle {
                        radius: Theme.borderRadius
                        IconImage {
                            source: "file://" + UserInfo.face
                            implicitHeight: 15
                            implicitWidth: 15
                            mipmap: true
                        }
                    }
                } 

                property var icon: Component {
                    Text {
                        text: "" // Nerd icon, nf-fa-user
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pointSize: Theme.fontSize / 1.2
                    }
                }

                sourceComponent: root.faceExists != "false" ? image : icon
            }
            
            Text {
                text: UserInfo.username
                color: Theme.text
                font.family: Theme.fontFamily
                font.pointSize: Theme.fontSize
            }
        }

    }

    Tooltip {
        parent: root
        visible: root.hoveredOver
        text: "left/right: open menu"
    }
}