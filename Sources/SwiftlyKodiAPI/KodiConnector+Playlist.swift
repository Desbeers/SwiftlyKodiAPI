//
//  KodiConnector+Playlist.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Get the current playlist
    @MainActor public func getCurrentPlaylist() async {
        if let playlist = await Playlist.getItems() {
            queue = playlist
        } else {
            queue = nil
        }
    }
}
