import QtQuick
import Quickshell
import Quickshell.Services.UPower

Rectangle {
    id: wrapper
    property real margin: 4
    property real batteryPercentage: Math.round(UPower.displayDevice.percentage * 100)

    border.width: 1
    border.color: "#45475a"
    radius: 4
    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: UPower.displayDevice.percentage; color: UPower.displayDevice.changeRate < 0 ? "#80f38ba8" : "#80a6e3a1" }
        GradientStop { position: UPower.displayDevice.percentage + 0.01; color: "transparent" }
    }

    implicitWidth: child.implicitWidth + margin * 4
    implicitHeight: 25 // set to fixed height so all widget match eachother


    Text {
        id: child
        x: wrapper.margin * 2
        y: wrapper.margin
        width: wrapper.width - wrapper.margin * 4
        height: wrapper.height - wrapper.margin * 2
        text: `bat ${wrapper.batteryPercentage}%`
        color: "#cdd6f4"
        font.family: "JetBrainsMono"
        font.bold: true
        font.pointSize: 10
    }
}