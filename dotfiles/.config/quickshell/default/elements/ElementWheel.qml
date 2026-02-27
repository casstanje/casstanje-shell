import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import './../'

SpinBox {
    id: root
    implicitHeight: 30
    to: items.length - 1
    value: initialValue
    required property list<string> items
    required property int initialValue
    property int newValue: initialValue
    property bool direction: false;

    onValueChanged: {
        direction = newValue < value;
        newValue = value;
        switchOutAnim.running = true;
    }

    textFromValue: function(value) {
        return items[value]
    }

    valueFromText: function(value) {
        for(var i = 0; i < items.length; i++) {
            if(value.toLowerCase() == items[i]) {
                return i;
            }
        }
        return root.value;
    }

    background: Rectangle {
        color: "transparent"
        border.width: 1
        radius: Theme.borderRadius
        border.color: Theme.surface
        Layout.fillWidth: true
        Layout.minimumWidth: 300
    }

    contentItem: WrapperRectangle {
        leftMargin: 20
        Layout.fillWidth: true
        Layout.minimumWidth: valueHolder.implicitWidth
        implicitHeight: valueHolder.height
        color: "transparent"
        ClippingRectangle {
            Layout.fillWidth: true
            color: "transparent"    
            Text {
                anchors.centerIn: parent
                id: valueHolder
                text: root.textFromValue(root.initialValue)
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
                    from: (valueHolder.parent.width / 2 - valueHolder.width / 2)
                    to: root.direction ? -valueHolder.width : valueHolder.parent.width
                    duration: 100
                    running: true
                    onFinished: {
                        valueHolder.text = root.textFromValue(root.newValue)
                        switchInAnim.running = true
                    }
                }

                NumberAnimation on x {
                    id: switchInAnim
                    from: !root.direction ? -valueHolder.width : valueHolder.parent.width
                    to: (valueHolder.parent.width / 2 - valueHolder.width / 2)
                    duration: 100
                    onFinished: {
                        valueHolder.anchors.centerIn = valueHolder.parent
                    }
                }
            }
        }
    }

    down.indicator: Rectangle {
        x: root.mirrored ? parent.width - width : 0
        height: parent.height
        implicitWidth: 20
        implicitHeight: 25
        color: root.down.pressed ? Theme.surface : "transparent"
        radius: Theme.borderRadius
        border.width: 0

        Text {
            text: "" /*nf-fa-caret_left*/
            color: enabled ? Theme.text : Theme.brightSurface
            anchors.fill: parent
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    up.indicator: Rectangle {
        x: !root.mirrored ? parent.width - width : 0
        height: parent.height
        implicitWidth: 20
        implicitHeight: 25
        color: root.up.pressed ? Theme.surface : "transparent"
        radius: Theme.borderRadius
        border.width: 0

        Text {
            text: "" /*nf-fa-caret_right*/
            color: enabled ? Theme.text : Theme.brightSurface
            anchors.fill: parent
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

}