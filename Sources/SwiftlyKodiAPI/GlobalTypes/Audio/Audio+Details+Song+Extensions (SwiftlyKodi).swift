//
//  Audio+Details+Song+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Audio.Details.Song {

    /// Play an ``Audio/Details/Song`` item
    /// - Parameter host: The ``HostItem`` to play the song
    public func play(host: HostItem) {
        Task {
            /// Check if this song is in the current playlist
            let audioPlaylist = await Playlist.getItems(host: host, playlistID: .audio)
            if let position = audioPlaylist?.firstIndex(where: { $0.id == id }) {
                Player.goTo(host: host, playerID: .audio, position: position)
            } else {
                Playlist.clear(host: host, playlistID: .audio)
                await Playlist.add(host: host, songs: [self])
                Player.open(host: host, playlistID: .audio)
            }
        }
    }
}

extension Array where Element == Audio.Details.Song {

    /// Play an array of ``Audio/Details/Song``
    /// - Parameters:
    ///   - host: The ``HostItem`` to play the songs
    ///   - shuffle: Bool to shuffle the songs or not
    public func play(host: HostItem, shuffle: Bool = false) {
        Task {
            /// Make sure party mode is off
            if await Player.getProperties(host: host, playerID: .audio).partymode {
                Player.setPartyMode(host: host, playerID: .audio)
            }
            Playlist.clear(host: host, playlistID: .audio)
            await Playlist.add(host: host, songs: self)
            Player.open(host: host, playlistID: .audio, shuffle: shuffle)
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
