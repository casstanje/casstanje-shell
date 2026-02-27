import 'singletons/'
import 'elements/'
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Scope {
    id: root

    

    Variants {
        model: Quickshell.screens
        PanelWindow {
            visible: Config.desktopMediaPlayerEnabled
            id: window
            required property var modelData
            screen: modelData

            anchors {
                bottom: true
                left: true
            }

            margins {
                bottom:  Theme.screenGap
                left: Theme.screenGap
            }

            aboveWindows: false
            exclusionMode: ExclusionMode.Ignore

            color: "transparent"

            implicitHeight: mediaPlayer.height
            implicitWidth: mediaPlayer.width

            WrapperRectangle {
                id: mediaPlayer
                radius: Theme.borderRadius
                color: "transparent"

                margin: 8

                ColumnLayout {
                    spacing: Theme.listSpacing
                    Text {
                        visible: (MprisController.activePlayer?.trackTitle ?? "") == ""
                        text: "NO MUSIC PLAYING"
                        color: Theme.subtext
                        font.pointSize: Theme.fontSize * 1.5
                        font.bold: false
                        font.italic: true
                    }


                    Loader {
                        property Component empty: Text {
                            text: ""
                        }
                        property Component info: ColumnLayout {
                            spacing: Theme.listSpacing
                            RowLayout {
                                visible: MprisController.activePlayer != null && MprisController.activePlayer.trackTitle != ""
                                spacing: 0
                                Text {
                                    text: "NOW PLAYING..."
                                    color: Theme.subtext
                                    font.pointSize: Theme.fontSize * 1.5
                                    font.bold: false
                                    font.italic: true
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                }
                                Text {
                                    visible: MprisController.activePlayer.positionSupported && MprisController.activePlayer.lengthSupported && MprisController.length < 9999999999 /*fix for twitch streams, plus probably some others*/
                                    property int positionMinutes: Math.floor(MprisController.activePlayer.position / 60)
                                    property int positionSeconds: Math.floor(MprisController.activePlayer.position - 60 * positionMinutes)
                                    property string positionString: (
                                        (positionMinutes.toString().length == 1 ? "0" + positionMinutes : positionMinutes) + ":" +
                                        (positionSeconds.toString().length == 1 ? "0" + positionSeconds : positionSeconds)
                                    )

                                    property int lengthMinutes: Math.floor(MprisController.activePlayer.length / 60)
                                    property int lengthSeconds: Math.floor(MprisController.activePlayer.length - 60 * lengthMinutes)
                                    property string lengthString: (
                                        (lengthMinutes.toString().length == 1 ? "0" + lengthMinutes : lengthMinutes) + ":" +
                                        (lengthSeconds.toString().length == 1 ? "0" + lengthSeconds : lengthSeconds)
                                    )
                                    text: positionString + "/" + lengthString
                                    font.pointSize: Theme.fontSize * 1.5
                                    font.italic: true
                                    color: Theme.subtext
                                }
                            }
                            RowLayout {
                                visible: MprisController.activePlayer != null && MprisController.activePlayer.trackTitle != ""
                                spacing: Theme.listSpacing * 2
                                WrapperRectangle {
                                    visible: MprisController.activePlayer.trackArtUrl != "" && Config.showAlbumArt
                                    id: albumArt
                                    implicitHeight: trackInfoAndControls.height
                                    color: "transparent"
                                    ClippingWrapperRectangle{
                                        radius: Theme.borderRadius
                                        Image {
                                            source: MprisController.activePlayer.trackArtUrl
                                            sourceSize.height: height
                                            width: paintedWidth
                                            fillMode: Image.PreserveAspectFit
                                            verticalAlignment: Qt.AlignTop
                                        }
                                    }
                                }
                                ColumnLayout {
                                    id: trackInfoAndControls
                                    spacing: Theme.listSpacing
                                    RowLayout {
                                        ColumnLayout {
                                            spacing: 0
                                            
                                            Text {
                                                text: MprisController.activePlayer.trackTitle
                                                color: Theme.text
                                                font.pointSize: Theme.fontSize * 1.8
                                                font.bold: true
                                                font.italic: true
                                            }
                                            Text {
                                                visible: text != ""
                                                text: (MprisController.activePlayer.trackArtist != "" ? MprisController.activePlayer.trackArtist : "") + (MprisController.activePlayer.trackAlbum != "" ? ", " + MprisController.activePlayer.trackAlbum : "")
                                                color: Theme.text
                                                font.pointSize: Theme.fontSize * 1.5
                                            }
                                        }
                                    }

                                    RowLayout {
                                        spacing: Theme.listSpacing
                                        visible: height > 0.5

                                        WrapperMouseArea {
                                            visible: MprisController.activePlayer.canGoPrevious
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                MprisController.activePlayer.previous()
                                            }
                                            WrapperRectangle {
                                                color: "transparent"
                                                implicitWidth: height
                                                leftMargin: 12
                                                topMargin: 1
                                                Text {
                                                    text: "󰒮" /*nf-md-skip_previous*/
                                                    color: Theme.text
                                                    font.pointSize: 23
                                                }
                                            }
                                        }

                                        WrapperMouseArea {
                                            visible: MprisController.activePlayer.canTogglePlaying
                                            id: playButton
                                            property bool isHovered: false
                                            hoverEnabled: true
                                            state: "NOT PRESSED"
                                            onEntered: {
                                                isHovered = true
                                            }
                                            onExited: {
                                                isHovered = false
                                            }
                                            cursorShape: Qt.PointingHandCursor

                                            onPressed: {
                                                state = "PRESSED"
                                            }

                                            onReleased: {
                                                state = "NOT PRESSED"
                                            }

                                            onClicked: {
                                                MprisController.activePlayer.togglePlaying()
                                            }

                                            states: [
                                                State {
                                                    name: "PRESSED"
                                                    PropertyChanges { target: playButtonVisuals; color: Theme.brightSurface }
                                                },
                                                State {
                                                    name: "NOT PRESSED"
                                                    PropertyChanges { target: playButtonVisuals; color: Theme.accent }
                                                }
                                            ]

                                            transitions: [
                                                Transition {
                                                    from: "PRESSED"
                                                    to: "NOT PRESSED"
                                                    ColorAnimation { target: playButtonVisuals; duration: 10}
                                                },
                                                Transition {
                                                    from: "NOT PRESSED"
                                                    to: "PRESSED"
                                                    ColorAnimation { target: playButtonVisuals; duration: 10}
                                                }
                                            ]

                                            WrapperRectangle {
                                                id: playButtonVisuals

                                                radius: height / 2
                                                color: Theme.accent
                                                margin: 8
                                                leftMargin: !MprisController.activePlayer.isPlaying ? 19 : 17.5
                                                topMargin: !MprisController.activePlayer.isPlaying ? 12.5 : 9.5
                                                implicitWidth: height
                                                implicitHeight: 50

                                                Text {
                                                    text: !MprisController.activePlayer.isPlaying ? "" /*nf-fa-play*/ : "" /*nf-fa-pause*/
                                                    color: Theme.background
                                                    font.pointSize: !MprisController.activePlayer.isPlaying ? 15 : 18
                                                }
                                            }
                                        }

                                        
                                        WrapperMouseArea {
                                            visible: MprisController.activePlayer.canGoNext
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                MprisController.activePlayer.next()
                                            }
                                            WrapperRectangle {
                                                color: "transparent"
                                                implicitWidth: height
                                                leftMargin: 12
                                                topMargin: 1

                                                Text {
                                                    text: "󰒭" /*nf-md-skip_next*/
                                                    color: Theme.text
                                                    font.pointSize: 23
                                                }
                                            }
                                        }

                                        Rectangle {
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                        sourceComponent: MprisController.activePlayer != null ? info : empty
                    }
                }
            }
        }
    }
}
