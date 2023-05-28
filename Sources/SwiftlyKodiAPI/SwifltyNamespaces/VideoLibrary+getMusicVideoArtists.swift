//
//  VideoLibrary+getMusicVideoArtists.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//
import Foundation

// MARK: VideoLibrary.getMusicVideoArtists

extension VideoLibrary {

    /// Find all Music Video Artists
    ///
    /// If the artist is not know in the Music database, a new Artist item will be created
    /// - Returns: All artists
    public static func getMusicVideoArtists() -> [Audio.Details.Artist] {
        var artistList: [Audio.Details.Artist] = []
        let allArtists = KodiConnector.shared.library.musicVideos
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
            if let artistDetails = KodiConnector.shared.library.artists.first(where: { $0.artist == artist }) {
                return artistDetails
            }
            /// Return an unknown artist
            return Audio.Details.Artist(media: .artist, title: artist, artistID: UUID().hashValue)
        }
    }
}
