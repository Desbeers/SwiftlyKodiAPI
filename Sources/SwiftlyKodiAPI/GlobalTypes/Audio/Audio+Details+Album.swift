//
//  Audio+Details+Album.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Audio.Details {

    /// Album details  (Global Kodi Type)
    struct Album: KodiItem, Sendable {

        /// # Calculated variables

        /// The ID of the album
        public var id: String { "\(media)+\(albumID)" }
        /// The Kodi ID of the album
        public var kodiID: Library.id { albumID }
        /// The type of media
        public var media: Library.Media = .album
        /// The location of the media file
        public var file: String = ""
        /// Calculated sort title
        public var sortByTitle: String {
            title.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
        }
        /// The poster of the album
        public var poster: String { thumbnail }
        /// The subtitle of the album
        public var subtitle: String { displayArtist }
        /// The details of the album
        public var details: String { year.description }
        /// The duration of the album
        public var duration: Int { albumDuration }
        /// The resume position of the album
        /// - Note: Not in use but needed by protocol
        public var resume = Video.Resume()
        /// The search string
        public var search: String {
            "\(title) \(displayArtist)"
        }

        /// # Audio.Details.Album

        public var albumDuration: Int = 0
        public var albumID: Library.id = 0
        public var albumLabel: String = ""
        public var albumStatus: String = ""
        public var compilation: Bool = false
        public var description: String = ""
        public var isBoxset: Bool = false
        public var lastPlayed: String = ""
        public var mood: [String] = []
        public var musicBrainzAlbumID: String = ""
        public var musicBrainzReleasegroupID: String = ""
        public var playcount: Int = 0
        public var releaseType: Audio.Album.ReleaseType = .album
        public var songGenres: [Audio.Details.Genres] = []
        public var sourceID: [Int] = []
        public var style: [String] = []
        public var theme: [String] = []
        public var totalDiscs: Int = 0
        public var type: String = ""

        /// # Audio.Details.Media

        public var artist: [String] = []
        public var artistID: [Int] = []
        public var displayArtist: String = ""
        public var musicBrainzAlbumArtistID: [String] = []
        public var originalDate: String = ""
        public var rating: Double = 0
        public var releaseDate: String = ""
        public var sortArtist: String = ""
        public var title: String = ""
        public var userRating: Int = 0
        public var votes: Int = 0
        public var year: Int = 0

        /// # Audio.Details.Base

        public var art = Media.Artwork()
        public var dateAdded: String = ""
        public var genre: [String] = []

        /// # Media.Details.Base

        public var fanart: String = ""
        public var thumbnail: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case albumDuration = "albumduration"
            case albumID = "albumid"
            case albumLabel = "albumlabel"
            case albumStatus = "albumstatus"
            case compilation
            case description
            case isBoxset = "isboxset"
            case lastPlayed = "lastplayed"
            case mood
            case musicBrainzAlbumID = "musicbrainzalbumid"
            case musicBrainzReleasegroupID = "musicbrainzreleasegroupid"
            case playcount
            case releaseType = "releasetype"
            case songGenres = "songgenres"
            case sourceID = "sourceid"
            case style
            case theme
            case totalDiscs = "totaldiscs"
            case type
            case artist
            case artistID = "artistid"
            case displayArtist = "displayartist"
            case musicBrainzAlbumArtistID = "musicbrainzalbumartistid"
            case originalDate = "originaldate"
            case rating
            case releaseDate = "releasedate"
            case sortArtist = "sortartist"
            case title
            case userRating = "userrating"
            case votes
            case year
            case art
            case dateAdded = "dateadded"
            case genre
            case fanart
            case thumbnail
        }
    }
}
