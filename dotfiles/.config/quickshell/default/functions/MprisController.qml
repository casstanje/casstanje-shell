pragma Singleton
pragma ComponentBehavior: Bound


import qs
import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import './../'
import Quickshell.Services.Mpris

Singleton {
	id: root;
	property list<MprisPlayer> players: Mpris.players.values
    property list<string> identities: players.map((x) => x.identity)
	property MprisPlayer trackedPlayer: null;
	property MprisPlayer activePlayer: trackedPlayer ?? players[0]
	onPlayersChanged: {
        if(trackedPlayer != null){
            var trackedPlayerStillExists = false

            for(var player of players){
                if(player == trackedPlayer){
                    trackedPlayerStillExists = true
                }
            }

            if(!trackedPlayerStillExists) trackedPlayer = null
        }
    }
}