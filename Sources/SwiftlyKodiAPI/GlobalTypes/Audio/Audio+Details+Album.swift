//
//  Audio+Details+Album.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Audio.Details {

    /// Album details (Global Kodi Type)
    struct Album: KodiItem, Sendable {

        /// # Calculated variables

        /// The ID of the album
        public var id: String = ""
        /// The Kodi ID of the album
        public var kodiID: Library.ID = 0
        /// The type of media
        public var media: Library.Media = .album
        /// The sort title of the album
        public var sortByTitle: String = ""
        /// The subtitle of the album ('displayArtist' property)
        public var subtitle: String = ""
        /// The details of the album ('year' property)
        public var details: String = ""
        /// The duration of the album
        public var duration: Int = 0
        /// The search string
        public var search: String = ""
        /// The poster of the album
        public var poster: String = ""

        /// # Not in use but needed by protocol

        /// The resume position of the album
        public var resume = Video.Resume()
        /// # Calculated variables
        /// The location of the album
        public var file: String = ""
        /// The stream details of the item
        public var streamDetails = Video.Streams()

        /// # Audio.Details.Album

        public var albumDuration: Int = 0
        public var albumID: Library.ID = 0
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

extension Audio.Details.Album {

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        self.albumDuration = try container.decode(Int.self, forKey: .albumDuration)
        self.albumID = try container.decode(Library.ID.self, forKey: .albumID)
        self.albumLabel = try container.decode(String.self, forKey: .albumLabel)
        self.albumStatus = try container.decode(String.self, forKey: .albumStatus)
        self.compilation = try container.decode(Bool.self, forKey: .compilation)
        self.description = try container.decode(String.self, forKey: .description)
        self.isBoxset = try container.decode(Bool.self, forKey: .isBoxset)
        self.lastPlayed = try container.decode(String.self, forKey: .lastPlayed)
        self.mood = try container.decode([String].self, forKey: .mood)
        self.musicBrainzAlbumID = try container.decode(String.self, forKey: .musicBrainzAlbumID)
        self.musicBrainzReleasegroupID = try container.decode(String.self, forKey: .musicBrainzReleasegroupID)
        self.playcount = try container.decode(Int.self, forKey: .playcount)
        self.releaseType = try container.decode(Audio.Album.ReleaseType.self, forKey: .releaseType)
        self.songGenres = try container.decode([Audio.Details.Genres].self, forKey: .songGenres)
        self.sourceID = try container.decode([Int].self, forKey: .sourceID)
        self.style = try container.decode([String].self, forKey: .style)
        self.theme = try container.decode([String].self, forKey: .theme)
        self.totalDiscs = try container.decode(Int.self, forKey: .totalDiscs)
        self.type = try container.decode(String.self, forKey: .type)
        self.artist = try container.decode([String].self, forKey: .artist)
        self.artistID = try container.decode([Int].self, forKey: .artistID)
        self.displayArtist = try container.decode(String.self, forKey: .displayArtist)
        self.musicBrainzAlbumArtistID = try container.decode([String].self, forKey: .musicBrainzAlbumArtistID)
        self.originalDate = try container.decode(String.self, forKey: .originalDate)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.sortArtist = try container.decode(String.self, forKey: .sortArtist)
        self.title = try container.decode(String.self, forKey: .title)
        self.userRating = try container.decode(Int.self, forKey: .userRating)
        self.votes = try container.decode(Int.self, forKey: .votes)
        self.year = try container.decode(Int.self, forKey: .year)
        self.art = try container.decode(Media.Artwork.self, forKey: .art)
        self.dateAdded = try container.decode(String.self, forKey: .dateAdded)
        self.genre = try container.decode([String].self, forKey: .genre)
        self.fanart = try container.decode(String.self, forKey: .fanart)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)

        /// # Custom variables

        self.id = "\(media)+\(albumID)"
        self.kodiID = albumID
        self.sortByTitle = title.simplifyString()
        self.search = "\(title) \(displayArtist)"
        self.subtitle = displayArtist
        self.details = year.description
        self.duration = albumDuration
        self.poster = thumbnail
    }
}
