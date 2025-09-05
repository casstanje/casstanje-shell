import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import './../'
import './../windows/'
import './../functions/'

ClickableContainer {
    id: root
    property var barRoot
    onWheel: function(wheel){
        var newValue = 0
        if(wheel.angleDelta.y > 0){
            newValue = Pipewire.defaultAudioSink.audio.volume + 0.05
        }else if(wheel.angleDelta.y < 0){
            newValue = Pipewire.defaultAudioSink.audio.volume - 0.05
        }
        if(newValue > 1) newValue = 1
        if(newValue < 0) newValue = 0
        Pipewire.defaultAudioSink.audio.volume = newValue
    }

    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    property point windowPosition: [0, 0]
    property bool showWindow: false
    property bool mouseInPopup: false
    onClicked: function(mouse){
        if(mouse.button == Qt.MiddleButton){
            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
        }else{
            windowPosition.x = root.parent.mapToItem(barRoot, root.x, 0).x
            windowPosition.y = barRoot.implicitHeight + 4
            showWindow = true
            UIVars.closePopupFunctions.push(function():Boolean{ 
                if(!root.mouseInPopup && !root.hoveredOver){
                    root.showWindow = false
                    return true
                }else return false
            })
        }
    }

    RowLayout {
        PwObjectTracker {
            objects: [
                Pipewire.defaultAudioSink
            ]
        }

        Text{
            text: Pipewire.defaultAudioSink.audio.muted ? 
            "" /*nf-fa-volume_xmark*/ : (
                Pipewire.defaultAudioSink.audio.volume > 0.5 ? 
                "" /*nf-fa-volume_high*/ : (
                    Pipewire.defaultAudioSink.audio.volume == 0 ? 
                    "" /*nf-fa-volume_off*/ : 
                    "" /*nf-fa-volume_low*/
                )
            )
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
            color: Pipewire.defaultAudioSink.audio.muted ? Theme.error : Theme.text
        }

        Text {
            text: Math.round((Pipewire.defaultAudioSink.audio.volume * 100)) + "%"
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
            color: Theme.text
        }

        VolumeControlWindow {
            visible: root.showWindow
            onEnteredCallback: function(){
                root.mouseInPopup = true
            }
            onExitedCallback: function(){
                root.mouseInPopup = false
            }
            closeWindow: function(){
                root.showWindow = false
            }
            anchor {
                window: root.barRoot.window
                rect.x: 0
                rect.y: 0
            }
            barRoot: root.barRoot
            button: root
        }
        Tooltip {
            parent: root
            visible: root.hoveredOver
            text: "left/right: open menu\nmiddle: toggle mute"
        }
    }

}