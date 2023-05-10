//
//  Audio+Details+Artist.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Audio.Details {

    /// Artist details
    struct Artist: KodiItem, Sendable {

        /// # Public Init
        public init(
            /// Media have to be set; this to identify the init
            media: Library.Media,
            playcount: Int = 0,
            file: String = "",
            lastPlayed: String = "",
            duration: Int = 0,
            userRating: Int = 0,
            resume: Video.Resume = Video.Resume(),
            artist: String = "",
            artistID: Library.id = 0,
            born: String = "",
            description: String = "",
            died: String = "",
            disambiguation: String = "",
            disbanded: String = "",
            formed: String = "",
            gender: String = "",
            instrument: [String] = [],
            isAlbumArtist: Bool = false,
            mood: [String] = [],
            musicBrainzArtistID: [String] = [],
            roles: [Audio.Artist.Roles] = [],
            songGenres: [Audio.Details.Genres] = [],
            sortName: String = "",
            style: [String] = [],
            type: String = "",
            yearsActive: [String] = [],
            art: Media.Artwork = Media.Artwork(),
            dateAdded: String = "",
            genre: [String] = [],
            fanart: String = "",
            thumbnail: String = ""
        ) {
            self.media = media
            self.playcount = playcount
            self.file = file
            self.lastPlayed = lastPlayed
            self.duration = duration
            self.userRating = userRating
            self.resume = resume
            self.artist = artist
            self.artistID = artistID
            self.born = born
            self.description = description
            self.died = died
            self.disambiguation = disambiguation
            self.disbanded = disbanded
            self.formed = formed
            self.gender = gender
            self.instrument = instrument
            self.isAlbumArtist = isAlbumArtist
            self.mood = mood
            self.musicBrainzArtistID = musicBrainzArtistID
            self.roles = roles
            self.songGenres = songGenres
            self.sortName = sortName
            self.style = style
            self.type = type
            self.yearsActive = yearsActive
            self.art = art
            self.dateAdded = dateAdded
            self.genre = genre
            self.fanart = fanart
            self.thumbnail = thumbnail
        }

        /// # Calculated variables

        /// The ID of the album
        public var id: String = ""
        /// The Kodi ID of the album
        public var kodiID: Library.id = 0
        /// The type of media
        public var media: Library.Media = .artist
        /// The title of the artist ('artist' property)
        public var title: String = ""
        /// The sort title of the artist
        /// - Note: If `sortName` is set for the item it will be used, else the `artist`
        public var sortByTitle: String = ""
        /// The subtitle of the album ('displayArtist' property)
        public var subtitle: String = ""
        /// The details of the album ('year' property)
        public var details: String = ""
        /// The search string
        public var search: String = ""
        /// The poster of the album
        public var poster: String = ""

        /// # Not in use but needed by protocol

        /// The resume position of the artist
        public var resume = Video.Resume()
        /// The location of the artist
        public var file: String = ""
        /// The rating of the artist
        public var rating: Double = 0
        /// The user rating of the artist
        public var userRating: Int = 0
        /// The playcount of the artist
        public var playcount: Int = 0
        /// The release year of the artist
        public var year: Int = 0
        /// The last played date of the artist
        public var lastPlayed: String = ""
        /// The duration of the artist
        public var duration: Int = 0

        /// # Audio.Details.Artist

        public var artist: String = ""
        public var artistID: Library.id = 0
        public var born: String = ""
        /// This always returns nil
        /// public var compilationArtist: Bool = false
        public var compilationArtist: Bool { !isAlbumArtist }
        public var description: String = ""
        public var died: String = ""
        public var disambiguation: String = ""
        public var disbanded: String = ""
        public var formed: String = ""
        public var gender: String = ""
        public var instrument: [String] = []
        public var isAlbumArtist: Bool = false
        public var mood: [String] = []
        public var musicBrainzArtistID: [String] = []
        public var roles: [Audio.Artist.Roles] = []
        public var songGenres: [Audio.Details.Genres] = []
        public var sortName: String = ""
        // public var sourceID: [Int] = []
        public var style: [String] = []
        public var type: String = ""
        public var yearsActive: [String] = []

        /// # Audio.Details.Base

        public var art = Media.Artwork()
        public var dateAdded: String = ""
        public var genre: [String] = []

        /// # Media.Details.Base

        public var fanart: String = ""
        public var thumbnail: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case artist
            case artistID = "artistid"
            case born
            /// This always returns nil
            /// case compilationArtist = "compilationartist"
            case description
            case died
            case disambiguation
            case disbanded
            case formed
            case gender
            case instrument
            case isAlbumArtist = "isalbumartist"
            case mood
            case musicBrainzArtistID = "musicbrainzartistid"
            case roles
            case songGenres = "songgenres"
            case sortName = "sortname"
            // case sourceID = "sourceid"
            case style
            case type
            case yearsActive = "yearsactive"
            case art
            case dateAdded = "dateadded"
            case genre
            case fanart
            case thumbnail
        }
    }
}

public extension Audio.Details.Artist {

    /// Custom decoder
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.artistID = try container.decode(Int.self, forKey: .artistID)
        self.born = try container.decode(String.self, forKey: .born)
        /// This always returns nil
        /// self.compilationArtist = try container.decodeIfPresent(Bool.self, forKey: .compilationArtist) ?? false
        self.description = try container.decode(String.self, forKey: .description)
        self.died = try container.decode(String.self, forKey: .died)
        self.disambiguation = try container.decode(String.self, forKey: .disambiguation)
        self.disbanded = try container.decode(String.self, forKey: .disbanded)
        self.formed = try container.decode(String.self, forKey: .formed)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.instrument = try container.decode([String].self, forKey: .instrument)
        self.isAlbumArtist = try container.decodeIfPresent(Bool.self, forKey: .isAlbumArtist) ?? false
        self.mood = try container.decode([String].self, forKey: .mood)
        self.musicBrainzArtistID = try container.decode([String].self, forKey: .musicBrainzArtistID)
        self.roles = try container.decodeIfPresent([Audio.Artist.Roles].self, forKey: .roles) ?? []
        self.songGenres = try container.decode([Audio.Details.Genres].self, forKey: .songGenres)
        self.sortName = try container.decode(String.self, forKey: .sortName)
        // self.sourceID = try container.decode([Int].self, forKey: .sourceID)
        self.style = try container.decode([String].self, forKey: .style)
        self.type = try container.decode(String.self, forKey: .type)
        self.yearsActive = try container.decode([String].self, forKey: .yearsActive)
        self.art = try container.decode(Media.Artwork.self, forKey: .art)
        self.dateAdded = try container.decode(String.self, forKey: .dateAdded)
        self.genre = try container.decode([String].self, forKey: .genre)
        self.fanart = try container.decode(String.self, forKey: .fanart)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)

        /// # Custom variables

        self.id = "\(media)+\(artistID)"
        self.kodiID = artistID
        self.title = artist
        self.sortByTitle = (sortName.isEmpty ? artist : sortName).simplify()
        self.subtitle = songGenres.map(\.title).joined(separator: " ∙ ")
        self.details = description
        self.search = artist
        self.poster = thumbnail
    }
}
