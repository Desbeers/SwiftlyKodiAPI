//
//  Audio+Details+Song.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Audio.Details {

    /// Song details
    struct Song: KodiItem, Sendable {

        /// # Calculated variables

        /// The ID of the song
        public var id: String = ""
        /// The Kodi ID of the song
        public var kodiID: Library.ID = 0
        /// The type of media
        public var media: Library.Media = .song
        /// The sort title of the song
        public var sortByTitle: String = ""
        /// The subtitle of the song ('displayArtist' property)
        public var subtitle: String = ""
        /// The details of the song ('album' property)
        public var details: String = ""
        /// The description of the song ('comment' property)
        public var description: String = ""
        /// The search string
        public var search: String = ""
        /// The poster of the song
        public var poster: String = ""

        /// # Not in use but needed by protocol

        /// The resume position of the song
        public var resume = Video.Resume()

        /// # Audio.Details.Song

        public var album: String = ""
        public var albumArtist: [String] = []
        public var albumArtistID: [Int] = []
        public var albumID: Library.ID = -1
        public var albumReleaseType: Audio.Album.ReleaseType = .album
        public var bitrate: Int = 0
        public var bpm: Int = 0
        public var channels: Int = 0
        public var comment: String = ""
        public var contributors: [Audio.Contributors] = []
        public var disc: Int = 0
        public var discTitle: String = ""
        public var displayComposer: String = ""
        public var displayConductor: String = ""
        public var displayLyricist: String = ""
        public var displayOrchestra: String = ""
        /// The duration of the song
        public var duration: Int = 0
        /// The location of the media file
        public var file: String = ""
        public var genreID: [Int] = []
        public var lastPlayed: String = ""
        public var lyrics: String = ""
        public var mood: [String] = []
        public var musicBrainzArtistID: [String] = []
        public var musicBrainzTrackID: String = ""
        public var playcount: Int = 0
        public var samplerate: Int = 0
        public var songID: Library.ID = 0
        public var sourceID: [Int] = []
        public var track: Int = 0

        /// # Audio.Details.Media

        public var artist: [String] = []
        public var artistID: [Int] = []
        public var displayArtist: String = ""
        public var musicBrainzAlbumArtistID: [String] = []
        public var originalDate: String = ""
        public var rating: Double = 0
        public var releaseDate: String = ""
        public var sortArtist: String = ""
        /// The title of the song
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
            case album
            case albumArtist = "albumartist"
            case albumArtistID = "albumartistid"
            case albumID = "albumid"
            case albumReleaseType = "albumreleasetype"
            case bitrate
            case bpm
            case channels
            case comment
            case contributors
            case disc
            case discTitle = "disctitle"
            case displayComposer = "displaycomposer"
            case displayConductor = "displayconductor"
            case displayLyricist = "displaylyricist"
            case displayOrchestra = "displayorchestra"
            case duration
            case file
            case genreID = "genreid"
            case lastPlayed = "lastplayed"
            // case lyrics
            case mood
            case musicBrainzArtistID = "musicbrainzartistid"
            case musicBrainzTrackID = "musicbrainztrackid"
            case playcount
            case samplerate
            case songID = "songid"
            case sourceID = "sourceid"
            case track
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

extension Audio.Details.Song {

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        self.album = try container.decode(String.self, forKey: .album)
        self.albumArtist = try container.decode([String].self, forKey: .albumArtist)
        self.albumArtistID = try container.decode([Int].self, forKey: .albumArtistID)
        self.albumID = try container.decode(Library.ID.self, forKey: .albumID)
        self.albumReleaseType = try container.decode(Audio.Album.ReleaseType.self, forKey: .albumReleaseType)
        self.bitrate = try container.decode(Int.self, forKey: .bitrate)
        self.bpm = try container.decode(Int.self, forKey: .bpm)
        self.channels = try container.decode(Int.self, forKey: .channels)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.contributors = try container.decode([Audio.Contributors].self, forKey: .contributors)
        self.disc = try container.decode(Int.self, forKey: .disc)
        self.discTitle = try container.decode(String.self, forKey: .discTitle)
        self.displayComposer = try container.decode(String.self, forKey: .displayComposer)
        self.displayConductor = try container.decode(String.self, forKey: .displayConductor)
        self.displayLyricist = try container.decode(String.self, forKey: .displayLyricist)
        self.displayOrchestra = try container.decode(String.self, forKey: .displayOrchestra)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.file = try container.decode(String.self, forKey: .file)
        self.genreID = try container.decode([Int].self, forKey: .genreID)
        self.lastPlayed = try container.decode(String.self, forKey: .lastPlayed)
        self.mood = try container.decode([String].self, forKey: .mood)
        self.musicBrainzArtistID = try container.decode([String].self, forKey: .musicBrainzArtistID)
        self.musicBrainzTrackID = try container.decode(String.self, forKey: .musicBrainzTrackID)
        self.playcount = try container.decode(Int.self, forKey: .playcount)
        self.samplerate = try container.decode(Int.self, forKey: .samplerate)
        self.songID = try container.decode(Library.ID.self, forKey: .songID)
        self.sourceID = try container.decode([Int].self, forKey: .sourceID)
        self.track = try container.decode(Int.self, forKey: .track)
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

        self.id = "\(media)+\(songID)"
        self.kodiID = songID
        self.sortByTitle = title.simplify()
        self.search = "\(title) \(displayArtist) \(album)"
        self.subtitle = displayArtist
        self.details = album
        self.description = comment
        self.poster = thumbnail
    }
}
