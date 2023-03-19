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
            /// Media have to be set; this to indentify the init
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

        /// The ID of the artist
        public var id: String { "\(media)+\(artistID)" }
        /// The Kodi ID of the artist
        public var kodiID: Library.id { artistID }
        /// The type of media
        public var media: Library.Media = .artist
        /// Calculated sort title
        /// - Note: If `sortName` is set for the item it will be used, else the `artist`
        public var sortByTitle: String { sortName.isEmpty ? artist : sortName }
        public var playcount: Int = 0
        /// The location of the media file
        public var file: String = ""
        public var lastPlayed: String = ""
        /// The poster of the artist
        public var poster: String { thumbnail }
        public var duration: Int = 0
        public var rating: Double = 0
        public var userRating: Int = 0
        /// The resume position of the artist
        /// - Note: Not in use but needed by protocol
        public var resume = Video.Resume()
        /// The search string
        public var search: String {
            "\(title)"
        }
        public var title: String { artist }
        /// The subtitle of the artist
        public var subtitle: String { songGenres.map(\.title).joined(separator: " ∙ ") }
        /// The details of the artist
        public var details: String { description }
        /// The release year of the item
        /// - Note: Not in use but needed by protocol
        public var year: Int = 0

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
    }
}
