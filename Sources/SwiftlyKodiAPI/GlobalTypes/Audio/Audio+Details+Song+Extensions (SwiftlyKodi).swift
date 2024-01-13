//
//  Audio+Details+Song+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Audio.Details.Song {

    /// Play an  ``Audio/Details/Song`` item
    public func play() {
        Task {
            /// Check if this song is in the current playlist
            let audioPlaylist = await Playlist.getItems(playlistID: .audio) 
            if let position = audioPlaylist?.firstIndex(where: { $0.id == id }) {
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
            if await Player.getProperties(playerID: .audio).partymode {
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
