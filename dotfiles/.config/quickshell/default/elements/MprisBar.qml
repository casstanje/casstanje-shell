import './../'
import './../singletons/'
import './../elements/'
import './../windows/'
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: root
    required property var barRoot
    property var trackedPlayer: null
    property list<MprisPlayer> players: MprisController.players
    property MprisPlayer firstPlayer: players[0]
    property MprisPlayer activePlayer: MprisController.activePlayer
    property bool windowHoveredOver: false
    property bool showWindow: false
    
    visible: Mpris.players.values.length > 0  && Config.mprisBarEnabled
    property string constructedMediaString: activePlayer.trackTitle == "" ? "no music playing (" + activePlayer.identity.toLowerCase() + ")" : (
        ((activePlayer.isPlaying ? "" /*nf-fa-pause*/ : "" /*nf-fa-play*/) + " ") +
        ((activePlayer.trackTitle != "" ? "<i>"+activePlayer.trackTitle+"</i>" : "") +
        (activePlayer.trackTitle != "" && 
            (activePlayer.trackArtist != "" || activePlayer.trackAlbum != "") ? " - " : "") +
        (activePlayer.trackArtist != "" ? activePlayer.trackArtist : "") +
        ((activePlayer.trackTitle != "" || activePlayer.trackArtist != "") && 
            activePlayer.trackAlbum != "" ? " - " : "") +
        (activePlayer.trackAlbum != "" ? activePlayer.trackAlbum : ""))
    )
    WrapperRectangle {
        visible: root.activePlayer.trackArtUrl != "" && Config.showAlbumArt
        id: albumArt
        Layout.fillHeight: true
        margin: 4
        color: "transparent"
        ClippingWrapperRectangle{
            radius: Theme.borderRadius
            Image {
                source: root.activePlayer.trackArtUrl
                sourceSize.height: height
                width: paintedWidth
                fillMode: Image.PreserveAspectFit
                verticalAlignment: Qt.AlignTop
            }
        }
    }
    
    ClickableContainer {
        id: shuffleToggle
        visible: root.activePlayer.shuffleSupported && Config.showShuffleButton
        onClicked: {
            root.activePlayer.shuffle = !root.activePlayer.shuffle
        }
        Text {
            text: "" /*nf-fa-shuffle*/
            color: root.activePlayer.shuffle ? Theme.accent : Theme.surface
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
        }
    }
    ClickableContainer {
        id: loopToggle
        visible: root.activePlayer.loopSupported && Config.showRepeatButton
        onClicked: {
            var loopState = root.activePlayer.loopState
            root.activePlayer.loopState = loopState == MprisLoopState.None ? MprisLoopState.Playlist : loopState ==  MprisLoopState.Playlist ? MprisLoopState.Track : MprisLoopState.None
        }
        Text {
            text: root.activePlayer.loopState == MprisLoopState.Track ? "1 " : "" /*nf-fa-repeat_alt*/
            color: root.activePlayer.loopState == MprisLoopState.None ? Theme.surface : Theme.accent
            font.family: Theme.fontFamily
            font.pointSize: Theme.fontSize
        }
    }
    ClippingRectangle {
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: mediaString.implicitWidth
        implicitHeight: mediaString.implicitHeight
        color: mediaString.showPosition ? Theme.brightSurface : "transparent"
        radius: Theme.borderRadius

        Rectangle {
            visible: mediaString.showPosition
            anchors.left: mediaString.left
            anchors.top: mediaString.top
            width: parent.width * (root.activePlayer.position / root.activePlayer.length)
            height: parent.height
            color: Theme.accent
            FrameAnimation {
                // only emit the signal when the position is actually changing.
                running: root.activePlayer.playbackState == MprisPlaybackState.Playing && mediaString.showPosition && root.activePlayer != null
                // emit the positionChanged signal every frame.
                onTriggered: if(root.activePlayer != null) root.activePlayer.positionChanged()
            }
        }

        WrapperMouseArea {
            property real maximumWidth: Config.maximumWidth != 0 ? Config.maximumWidth :
                root.parent.width - 
                    (albumArt.visible ? 
                        (albumArt.width + root.spacing) * 2 : 0) + 
                            (shuffleToggle.visible ? shuffleToggle.width + root.spacing : 0) + 
                                (loopToggle.visible ? loopToggle.width + root.spacing : 0)
            onMaximumWidthChanged: {
                if(implicitWidth > maximumWidth){
                    implicitWidth = maximumWidth
                } else {
                    implicitWidth = undefined
                }
            }
            
            property var showPosition: root.activePlayer.positionSupported && Config.showPosition
            margin: showPosition ? 1 : 0
            anchors.centerIn: parent
            id: mediaString
            onWheel: function(wheel){
                if(wheel.angleDelta.y > 0 && root.activePlayer.canGoNext){
                    root.activePlayer.next()
                }else if(wheel.angleDelta.y < 0 && root.activePlayer.canGoPrevious){
                    root.activePlayer.next()
                }
            }
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: function(mouse) {
                if(mouse.button == Qt.LeftButton && root.activePlayer.canTogglePlaying){
                root.activePlayer.togglePlaying() 
                }else if(mouse.button == Qt.RightButton){
                    root.showWindow = true
                    UIVars.closePopupFunctions.push(function():Boolean{ 
                        if(!root.windowHoveredOver && !mediaString.hoveredOver){
                            root.showWindow = false
                            return true
                        }else return false
                    })
                }
            }

            hoverEnabled: true
            property bool hoveredOver: false
            onEntered: hoveredOver = true
            onExited: hoveredOver = false
            cursorShape: Qt.PointingHandCursor

            WrapperRectangle {
                id: rectangle
                color: parent.hoveredOver ? Theme.brightSurface : Theme.background
                margin: Theme.containerPadding
                leftMargin: Theme.containerPadding * 2
                rightMargin: Theme.containerPadding * 2
                radius: Theme.borderRadius
                border.width: mediaString.showPosition ? 0 : Theme.smallBorderWidth
                border.color: mediaString.showPosition ? "transparent" : Theme.surface
                Text {
                    text: root.constructedMediaString
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pointSize: Theme.fontSize
                    elide: Text.ElideRight
                }
            }

            Tooltip {
                parent: mediaString
                visible: mediaString.hoveredOver
                text: "scroll up/down: switch song next/prev\nleft: toggle playing\nright: open menu"
            }
        }

    }

    WrapperRectangle { // Centers the song text in the middle by adding an item with the same width as the album art on the opposite side
        visible: root.activePlayer.trackArtUrl != "" && Config.showAlbumArt
        Layout.fillHeight: true
        margin: 4
        color: "transparent"
        implicitWidth: albumArt.implicitWidth
    }

    MprisWindow {
        id: mprisWindow
        visible: root.showWindow

        onEnteredCallback: function(){
            root.windowHoveredOver = true
        }
        onExitedCallback: function(){
            root.windowHoveredOver = false
        }
        anchor {
            window: root.barRoot.window
            rect.x: 0
            rect.y: 0
        }

        screen: root.barRoot.window.screen
        barRoot: root.barRoot
        button: root

        activePlayer: root.activePlayer
        players: root.players
    }
}