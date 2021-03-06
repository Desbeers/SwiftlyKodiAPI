//
//  AudioLibrary+Songs+Extensions.swift
//  
//
//  Created by Nick Berendsen on 16/07/2022.
//

import Foundation

extension Audio.Details.Song {
    
    /// Play an  ``Audio/Details/Song`` item
    public func play() {
        Task {
            /// Check if this song is in the current playlist
            if let position = self.playlistID {
                Player.goTo(playerID: .audio, position: position)
            } else {
                Playlist.clear(playlistID: .audio)
                await Playlist.add(songs: [self])
                Player.open(playlistID: .audio)
            }
        }
    }
}

extension Array where Element == Audio.Details.Song {
    
    /// Play an array of ``Audio/Details/Song``
    public func play(shuffle: Bool = false) {
        Task {
            /// Make sure party mode is off
            if KodiConnector.shared.player.properies.partymode {
                Player.setPartyMode(playerID: .audio)
            }
            Playlist.clear(playlistID: .audio)
            await Playlist.add(songs: self)
            Player.open(playlistID: .audio, shuffle: shuffle)
        }
    }
}

extension Array where Element == Audio.Details.Song {

    /// Search an array of ``Audio/Details/Song`` by the a query
    /// - Parameter query: The search query
    /// - Returns: An array of ``Audio/Details/Song``
    public func search(_ query: String) -> [Audio.Details.Song] {
        let searchMatcher = Search.Matcher(query: query)
        return self.filter { songs in
            return searchMatcher.matches(songs.search)
        }
    }
}
