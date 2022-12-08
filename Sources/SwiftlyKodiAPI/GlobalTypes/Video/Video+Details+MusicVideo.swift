//
//  Video+Details+MusicVideo.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// Music video details
    struct MusicVideo: KodiItem {

        /// # Calculated variables

        public var id: String { "\(media)+\(musicVideoID)" }
        public var media: Library.Media = .musicVideo
        public var sortByTitle: String { title }
        public var poster: String { thumbnail }
        public var subtitle: String { artist.joined(separator: " ∙ ") }
        public var details: String { album.isEmpty ? genre.joined(separator: " ∙ ") : album }
        /// The search string
        public var search: String {
            "\(title) \(artist.joined(separator: " ")) \(album)"
        }

        /// # Video.Details.MusicVideo

        public var album: String = ""
        public var artist: [String] = []
        public var genre: [String] = []
        public var musicVideoID: Library.id = 0
        public var premiered: String = ""
        public var rating: Double = 0
        public var studio: [String] = []
        public var tag: [String] = []
        public var track: Int = 0
        public var userRating: Int = 0
        public var year: Int = 0

        /// # Video.Details.File

        public var director: [String] = []
        public var resume = Video.Resume()
        public var runtime: Int = 0
        public var streamDetails = Video.Streams()

        /// # Video.Details.Item

        public var dateAdded: String = ""
        public var file: String = ""
        public var lastPlayed: String = ""
        public var plot: String = ""

        /// # Video.Details.Media

        public var title: String = ""

        /// # Video.Details.Base

        public var art = Media.Artwork()
        public var playcount: Int = 0

        /// # Media.Details.Base

        public var fanart: String = ""
        public var thumbnail: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case album
            case artist
            case genre
            case musicVideoID = "musicvideoid"
            case premiered
            case rating
            case studio
            case tag
            case track
            case userRating = "userrating"
            case year
            case director
            case resume
            case runtime
            case streamDetails = "streamdetails"
            case dateAdded = "dateadded"
            case file
            case lastPlayed = "lastplayed"
            case plot
            case title
            case art
            case playcount
            case fanart
            case thumbnail
        }
    }
}
