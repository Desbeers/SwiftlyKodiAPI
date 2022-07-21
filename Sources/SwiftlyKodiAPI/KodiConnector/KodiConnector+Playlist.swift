//
//  KodiConnector+Playlist.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Get the current playlist for the active player
    @MainActor public func getCurrentPlaylist() async {
        await task.getCurrentPlaylist.submit { [self] in
            
            player.audioPlaylist = await Playlist.getItems(playlistID: .audio)
            player.videoPlaylist = await Playlist.getItems(playlistID: .video) 
            
//            /// Check if we have an active player
//            //if let playerID = await getPlayerID() {
//            if player.playlistID != .none {
//                if let playlist = await Playlist.getItems(playlistID: player.playlistID) {
//                    queue = playlist
//                }
//            } else {
//                queue = nil
//            }
        }
    }
}
