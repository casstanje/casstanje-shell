import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import './../'


RowLayout {
    id: root

    required property list<string> model
    property bool direction
    property string newValue
    property int currentIndex: 0
    property int startIndex
    property bool justSetNewValue: false
    function changeValue(bool) {
        switchOutAnim.running = true
    }
    Component.onCompleted: {
        newValue = model[currentIndex]
        switchOutAnim.running = true
        startIndex = currentIndex
    }

    ClickableContainer {
        enabled: root.currentIndex != 0
        onClicked: {
            if(root.currentIndex != 0){
                root.direction = false
                root.newValue = root.model[root.currentIndex - 1]
                if(!root.justSetNewValue) root.currentIndex -= 1
                root.changeValue(false)
            }
        }
        Text {
            text: "" /*nf-fa-caret_left*/
            color: root.currentIndex != 0 ? Theme.text : Theme.brightSurface
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
        }
    }
    ClippingRectangle {
        Layout.fillWidth: true
        implicitHeight: valueHolder.height
        Layout.minimumWidth: valueHolder.implicitWidth
        id: valueHolderParent
        color: "transparent"
        Text {
            anchors.centerIn: parent
            id: valueHolder
            text: root.model[root.startIndex]
            horizontalAlignment: Qt.AlignHCenter
            color: Theme.text
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
            font.capitalization: Font.AllLowercase
            NumberAnimation on x {
                onStarted: {
                    valueHolder.anchors.centerIn = undefined
                }

                
                id: switchOutAnim
                from: (valueHolderParent.width / 2 - valueHolder.width / 2)
                to: root.direction ? -valueHolder.width : valueHolderParent.width
                duration: 100
                running: true
                onFinished: {
                    valueHolder.text = root.newValue
                    switchInAnim.running = true
                }
            }

            NumberAnimation on x {
                id: switchInAnim
                from: !root.direction ? -valueHolder.width : valueHolderParent.width
                to: (valueHolderParent.width / 2 - valueHolder.width / 2)
                duration: 100
                onFinished: {
                    valueHolder.anchors.centerIn = valueHolder.parent
                }
            }
        }
    }
    ClickableContainer {
        enabled: root.currentIndex != root.model.length - 1
        onClicked: {
            if(root.currentIndex != root.model.length - 1){
                root.direction = true
                root.newValue = root.model[root.currentIndex + 1]
                if(!root.justSetNewValue) root.currentIndex += 1
                root.changeValue(true)
            }
        }
        Text {
            text: "" /*nf-fa-caret_right*/
            color: root.currentIndex != root.model.length - 1 ? Theme.text : Theme.brightSurface
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
        }
    }
}