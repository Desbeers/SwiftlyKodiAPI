//
//  Audio+Details+Song.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Audio.Details {
    
    /// Song details
    struct Song: KodiItem {
        
        /// # Calculated variables
        
        public var id: Int { songID }
        public var media: Library.Media = .song
        public var sortByTitle: String { title }
        public var poster: String { thumbnail }
        public var subtitle: String { displayArtist }
        
        /// The search string
        public var search: String {
            "\(title) \(displayArtist) \(album)"
        }
        
        /// # Audio.Details.Song
        
        public var album: String = ""
        public var albumArtist: [String] = []
        public var albumArtistID: [Int] = []
        public var albumID: Int = 0
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
        public var duration: Int = 0
        public var file: String = ""
        public var genreID: [Int] = []
        public var lastPlayed: String = ""
        public var lyrics: String = ""
        public var mood: [String] = []
        public var musicBrainzArtistID: [String] = []
        public var musicBrainzTrackID: String = ""
        public var playcount: Int = 0
        public var samplerate: Int = 0
        public var songID: Int = 0
        public var sourceID: [Int] = []
        public var track: Int = 0
        
        /// # Audio.Details.Media
        
        public var artist: [String] = []
        public var artistID: [Int] = []
        public var displayArtist: String = ""
        public var musicBrainzAlbumArtistID: [String] = []
        public var originalDate: String = ""
        public var rating: Int = 0
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
            //case lyrics
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
