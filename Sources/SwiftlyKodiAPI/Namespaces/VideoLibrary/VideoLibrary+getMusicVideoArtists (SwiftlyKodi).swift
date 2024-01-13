//
//  VideoLibrary+getMusicVideoArtists.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

// MARK: getMusicVideoArtists

extension VideoLibrary {

    /// Get all Music Video Artists (SwiftlyKodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All artists
    /// - Note: If the artist is not know in the Music database, a new Artist item will be created
    public static func getMusicVideoArtists(library: Library.Items) -> [Audio.Details.Artist] {
        var artistList: [Audio.Details.Artist] = []
        let allArtists = library.musicVideos
            .unique { $0.artist }
            .flatMap { $0.artist }
        for artist in allArtists {
            artistList.append(artistItem(artist: artist))
        }
        return artistList

        /// Convert an 'artist' string to a `KodiItem`
        /// - Parameter artist: Name of the artist
        /// - Returns: A `KodiItem`
        func artistItem(artist: String) -> Audio.Details.Artist {
            if let artistDetails = library.artists.first(where: { $0.artist == artist }) {
                return artistDetails
            }
            /// Return an unknown artist with an unique ID
            let id = UUID().hashValue
            return Audio.Details.Artist(
                id: String(id),
                media: .artist,
                title: artist,
                artist: artist,
                artistID: UUID().hashValue,
                sortByTitle: artist.removePrefixes(["The"])
            )
        }
    }
}
