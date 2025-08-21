import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell.Services.Mpris

RowLayout {
    spacing: 8;
    id: root
    property MprisPlayer activePlayer: MprisController.activePlayer
    ClippingWrapperRectangle {
        radius: 4
        IconImage {
            source: root.activePlayer.trackArtUrl
            implicitSize: 30
        }
        visible: root.activePlayer != null && root.activePlayer.trackTitle != "" && root.activePlayer.trackTitle != null
    }
    ClickableContainer {
        clickAction: function() {
            root.activePlayer.togglePlaying()
        }
        wheelUpAction: function(){
            root.activePlayer.next()
        }
        wheelDownAction: function() {
            root.activePlayer.previous()
        }
        child: Text {
            text: root.activePlayer != null && root.activePlayer.trackTitle != "" && root.activePlayer.trackTitle != null ? `${root.activePlayer.isPlaying ? '' : ''} ${root.activePlayer.trackTitle != null ?  `<i>${root.activePlayer.trackTitle}</i>` : ""}${root.activePlayer.trackArtist != null ?  ` - ${root.activePlayer.trackArtist}` : ""}${root.activePlayer.trackAlbum != null ? ` - ${root.activePlayer.trackAlbum}` : ""}` : "No music D:"
            color: "#cdd6f4"
            font.bold: true
            font.pointSize: 10
            font.family: "JetBrainsMono"
            elide: Text.ElideRight
        }
        maxWidth: 420
    }
}