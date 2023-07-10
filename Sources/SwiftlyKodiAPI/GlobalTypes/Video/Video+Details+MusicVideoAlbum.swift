//
//  Video+Details+MusicVideoAlbum.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// Music Video Album details (SwiftltKodi Type)
    ///
    /// Kodi does not have such item
    struct MusicVideoAlbum: KodiItem {

        /// # Public Init

        public init(
            album: Video.Details.MusicVideo,
            musicVideos: [Video.Details.MusicVideo]
        ) {
            self.artist = album.artist
            self.album = album.album
            self.year = album.year
            self.art = album.art
            self.poster = album.poster
            self.fanart = album.fanart
            self.thumbnail = album.thumbnail
            /// Set the watched state for an album
            if musicVideos.filter({ $0.playcount == 0 }).isEmpty {
                self.playcount = 1
            }
            self.musicVideos = musicVideos
        }

        /// # Protocol variables

        public var id: String { album }
        public var media: Library.Media = .musicVideoAlbum
        public var title: String { album }
        public var subtitle: String { artist.joined(separator: " ∙ ") }
        public var details: String = ""
        public var description: String = ""
        /// Calculated sort title
        /// - Note: Kodi has no sortTitle for Music Video album title
        public var sortByTitle: String {
            album.removePrefixes(["De", "The", "A"])
        }
        public var poster: String

        public var musicVideos: [Video.Details.MusicVideo]

        /// # Not in use but needed by protocol

        public var kodiID: Library.ID = 0
        public var dateAdded: String = ""
        public var lastPlayed: String = ""
        public var rating: Double = 0
        public var userRating: Int = 0
        public var file: String = ""
        public var duration: Int = 0
        public var resume = Video.Resume()
        public var search: String = ""


        /// # Video.Details.MusicVideo

        public var album: String
        public var artist: [String]
        public var year: Int

        /// # Video.Details.Base

        public var art: Media.Artwork
        public var playcount: Int = 0

        /// # Media.Details.Base

        public var fanart: String
        public var thumbnail: String
    }
}
