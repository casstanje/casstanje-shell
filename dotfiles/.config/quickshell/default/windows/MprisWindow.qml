import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import './../'
import './../elements/'
import './../singletons/'
import Quickshell.Services.Mpris

PopupWindow {
    id: root
    required property MprisPlayer activePlayer
    required property list<MprisPlayer> players
    required property ShellScreen screen
    required property var barRoot
    required property var button
    property bool direction: false // False for left, True for right
    property var onEnteredCallback: function(){}
    property var onExitedCallback: function(){}
    property bool shouldUpdatePlayer: true
    function updateMenu() {
        shouldUpdatePlayer = false
        playerWheel.newValue = activePlayer.identity
        playerWheel.currentIndex = MprisController.identities.indexOf(activePlayer.identity)
        playerWheel.model = MprisController.identities
        playerWheel.changeValue(true)
        shouldUpdatePlayer = true
    }
    onActivePlayerChanged: {
        updateMenu()
    }
    onPlayersChanged: {
        updateMenu()
    }
    color: "transparent"
    implicitHeight: screen.height
    implicitWidth: screen.width
    mask: Region { item: mouseArea }
    
    WrapperMouseArea {
        hoverEnabled: true
        onEntered: root.onEnteredCallback()
        onExited: root.onExitedCallback()
        x: Math.round(root.button.parent.mapToItem(root.barRoot, root.button.x, 0).x + root.button.width / 2 - width / 2)
        y: Math.round(root.barRoot.implicitHeight)
        id: mouseArea
        ClippingRectangle {
            id: clipper
            implicitHeight: container.implicitHeight
            implicitWidth: container.implicitWidth
            color: "transparent"
            NumberAnimation on implicitHeight {
                id: spawnAnim
                running: root.visible
                from: 0; to: container.implicitHeight
                duration: 150
            }

            WrapperRectangle {
                id: container
                margin: 8
                Layout.minimumWidth: 400

                color: Theme.background
                radius: Theme.borderRadius
                border.width: Theme.borderWidth
                border.color: Theme.accent

                ColumnLayout {
                    id: songColumn
                    ElementWheel {
                        id: playerWheel
                        model: MprisController.identities
                        currentIndex: MprisController.identities.indexOf(root.activePlayer.identity)
                        justSetNewValue: true
                        onNewValueChanged: {
                            if(!root.shouldUpdatePlayer) return
                            var result = MprisController.players.filter(x => {
                                return x.identity === newValue
                            })[0]
                            MprisController.trackedPlayer = result
                        }
                    }
                
                    ColumnLayout {
                        Layout.fillWidth: true
                        ClippingWrapperRectangle{
                            visible: root.activePlayer.trackArtUrl != ""
                            radius: Theme.borderRadius
                            implicitWidth: Config.albumArtMenuSize
                            Layout.alignment: Qt.AlignHCenter
                            Image {
                                source: root.activePlayer.trackArtUrl
                                sourceSize.width: width
                                fillMode: Image.PreserveAspectFit
                                verticalAlignment: Qt.AlignTop
                            }
                        }

                        ColumnLayout {
                            id: songInfoAndControls
                            Layout.fillWidth: true
                            spacing: 2
                            Layout.alignment: Qt.AlignTop
                            Text {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter
                                text: root.activePlayer.trackTitle != "" ? root.activePlayer.trackTitle : "no music playing"
                                font.family: Theme.fontFamily
                                color: Theme.text
                                font.pointSize: Theme.fontSize * 1.1
                                horizontalAlignment: Qt.AlignHCenter
                            }
                            ColumnLayout {
                                visible: root.activePlayer.trackArtist != "" || root.activePlayer.trackAlbum != ""
                                Layout.fillWidth: true
                                spacing: 0
                                Text {
                                    visible: root.activePlayer.trackArtist != ""
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                    text: root.activePlayer.trackArtist
                                    font.family: Theme.fontFamily
                                    color: Theme.subtext
                                    font.pointSize: Theme.fontSize * 1
                                    horizontalAlignment: Qt.AlignHCenter
                                }
                                Text {
                                    visible: root.activePlayer.trackAlbum != ""
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                    text: root.activePlayer.trackAlbum
                                    font.family: Theme.fontFamily
                                    color: Theme.subtext
                                    font.pointSize: Theme.fontSize * 1
                                    horizontalAlignment: Qt.AlignHCenter
                                }
                            }
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                id: controlsContainer
                                visible: root.activePlayer.canControl
                                spacing: 2
                                property real iconSizeMultiplier: 1.6
                                ClickableContainer {
                                    visible: root.activePlayer.shuffleSupported && Config.showShuffleButton
                                    onClicked: {
                                        root.activePlayer.shuffle = !root.activePlayer.shuffle
                                    }
                                    Text {
                                        text: "" /*nf-fa-shuffle*/
                                        color: root.activePlayer.shuffle ? Theme.accent : Theme.surface
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize * controlsContainer.iconSizeMultiplier
                                    }
                                }
                                ClickableContainer {
                                    visible: root.activePlayer.canSeek
                                    onClicked: {
                                        root.activePlayer.seek(-10)
                                    }
                                    Text {
                                        text: "󰴪" /*nf-md-rewind_10*/
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize * controlsContainer.iconSizeMultiplier
                                    }
                                }
                                ClickableContainer {
                                    visible: root.activePlayer.canGoPrevious
                                    onClicked: {
                                        root.activePlayer.previous()
                                    }
                                    Text {
                                        text: "󰒮" /*nf-md-skip_previous*/
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize * controlsContainer.iconSizeMultiplier
                                    }
                                }
                                ClickableContainer {
                                    visible: root.activePlayer.canTogglePlaying
                                    onClicked: {
                                        root.activePlayer.togglePlaying()
                                    }
                                    Text {
                                        text: !root.activePlayer.isPlaying ? "󰐊" /*nf-md-play*/ : "󰏤" /*nf-md-pause*/
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize * controlsContainer.iconSizeMultiplier * 1.3
                                    }
                                }
                                ClickableContainer {
                                    visible: root.activePlayer.canGoNext
                                    onClicked: {
                                        root.activePlayer.next()
                                    }
                                    Text {
                                        text: "󰒭" /*nf-md-skip_next*/
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize * controlsContainer.iconSizeMultiplier
                                    }
                                }
                                ClickableContainer {
                                    visible: root.activePlayer.canSeek
                                    onClicked: {
                                        root.activePlayer.seek(10)
                                    }
                                    Text {
                                        text: "󰵱" /*nf-md-fast_forward_10*/
                                        color: Theme.text
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize * controlsContainer.iconSizeMultiplier
                                    }
                                }
                                
                                ClickableContainer {
                                    visible: root.activePlayer.loopSupported && Config.showRepeatButton
                                    onClicked: {
                                        var loopState = root.activePlayer.loopState
                                        root.activePlayer.loopState = loopState == MprisLoopState.None ? MprisLoopState.Playlist : loopState ==  MprisLoopState.Playlist ? MprisLoopState.Track : MprisLoopState.None
                                    }
                                    Text {
                                        text: root.activePlayer.loopState == MprisLoopState.Track ? "1 " : "" /*nf-fa-repeat_alt*/
                                        color: root.activePlayer.loopState == MprisLoopState.None ? Theme.surface : Theme.accent
                                        font.family: Theme.fontFamily
                                        font.pointSize: Theme.fontSize * controlsContainer.iconSizeMultiplier
                                    }
                                }
                            }

                            RowLayout {
                                visible: root.activePlayer.volumeSupported && Config.showVolumeSlider
                                implicitWidth: 300 < parent.implicitWidth ? parent.implicitWidth : 300
                                Slider {
                                    id: volumeSlider
                                    from: 0
                                    to: 1
                                    value: root.activePlayer.volume
                                    onValueChanged: {
                                        root.activePlayer.volume = volumeSlider.value
                                    }
                                    Layout.fillWidth: true
                                    background: Rectangle {
                                        implicitHeight: 7
                                        height: implicitHeight
                                        y: volumeSlider.height / 2 - height / 2
                                        implicitWidth: volumeSlider.availableWidth
                                        radius: Theme.borderRadius
                                        color: Theme.surface

                                        Rectangle {
                                            implicitWidth: volumeSlider.visualPosition * parent.implicitWidth
                                            height: parent.height
                                            color: Theme.accent
                                            radius: Theme.borderRadius
                                        }
                                    }

                                    handle: Rectangle {
                                        x: volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                                        y: volumeSlider.availableHeight / 2 - height / 2
                                        implicitWidth: 16
                                        implicitHeight: 16
                                        radius: 8
                                        color: volumeSlider.pressed ? Theme.brightSurface : Theme.surface
                                        border.color: Theme.brightSurface
                                    }
                                }
                                Text {
                                    property string percentage: Math.round(volumeSlider.value * 100).toString()
                                    text: (percentage.length == 2 ? " " : (percentage.length == 1 ? "  " : "")) + percentage + "%"
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pointSize: Theme.fontSize
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}