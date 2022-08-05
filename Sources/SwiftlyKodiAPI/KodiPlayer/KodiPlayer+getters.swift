//
//  KodiPlayer+getters.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiPlayer {

    /// Get the first active player ID
    /// - Returns: The active  `playerID`, if any, else `nil`
    func getPlayerID() async -> Player.ID? {
        if let players = await Player.getActivePlayers(), let activePlayer = players.first {
            return activePlayer
        }
        return nil
    }
    
    /// Get the properties of the player
    func getPlayerProperties() async {
        await task.getPlayerProperties.submit {
            var properties = Player.Property.Value()
            /// Check if we have an active player
            if let playerID = await self.getPlayerID() {
                properties = await Player.getProperties(playerID: playerID)
            }
            await self.setProperties(properties: properties)
        }
    }
    
    /// Get the optional current item of the player
    func getPlayerItem() async {
        await task.getPlayerItem.submit {
            var currentItem: (any KodiItem)?
            /// Check if we have an active player
            if let playerID = await self.getPlayerID() {
                currentItem = await Player.getItem(playerID: playerID)
            }
            await self.setCurrentItem(item: currentItem)
        }
    }
    
    /// Get the current playlist for the active player
    func getCurrentPlaylist() async {
        await task.getCurrentPlaylist.submit { [self] in
            await setAudioPlaylist(playlist: await Playlist.getItems(playlistID: .audio) ?? [])
            await setVideoPlaylist(playlist: await Playlist.getItems(playlistID: .video) ?? [])
            await setPlaylistUpdate()
        }
    }
}