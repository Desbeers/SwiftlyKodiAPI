//
//  Audio+Details+Artist.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Audio.Details {
    
    /// Artist details
    struct Artist: LibraryItem {
        

        
        
        /// # Protocol variables
        
        public var id: Int { artistID }
        public var media: Library.Media = .album
        public var playcount: Int = 0
        public var file: String = ""
        
        public var lastPlayed: String = ""
        
        public var artist: String = ""
        public var artistID: Int = 0
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
        public var sourceID: [Int] = []
        public var style: [String] = []
        public var type: String = ""
        public var yearsActive: [String] = []
        
        /// Audio.Details.Base
        
        public var art = Media.Artwork()
        public var dateAdded: String = ""
        public var genre: [String] = []
        
        /// Media.Details.Base
        
        public var fanart: String = ""
        public var thumbnail: String = ""
        
        /// Calculated stuff
        
        public var title: String { artist }
        
        public var subtitle: String { "subtitle" }
        
        public var details: String { description }
        
        /// Coding keys
        
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
            case sourceID = "sourceid"
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
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Audio.Details.Artist.CodingKeys> = try decoder.container(keyedBy: Audio.Details.Artist.CodingKeys.self)
        self.artist = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.artist)
        self.artistID = try container.decode(Int.self, forKey: Audio.Details.Artist.CodingKeys.artistID)
        self.born = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.born)
        /// This always returns nil
        /// self.compilationArtist = try container.decodeIfPresent(Bool.self, forKey: Audio.Details.Artist.CodingKeys.compilationArtist) ?? false
        self.description = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.description)
        self.died = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.died)
        self.disambiguation = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.disambiguation)
        self.disbanded = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.disbanded)
        self.formed = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.formed)
        self.gender = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.gender)
        self.instrument = try container.decode([String].self, forKey: Audio.Details.Artist.CodingKeys.instrument)
        self.isAlbumArtist = try container.decodeIfPresent(Bool.self, forKey: Audio.Details.Artist.CodingKeys.isAlbumArtist) ?? false
        self.mood = try container.decode([String].self, forKey: Audio.Details.Artist.CodingKeys.mood)
        self.musicBrainzArtistID = try container.decode([String].self, forKey: Audio.Details.Artist.CodingKeys.musicBrainzArtistID)
        self.roles = try container.decodeIfPresent([Audio.Artist.Roles].self, forKey: Audio.Details.Artist.CodingKeys.roles) ?? []
        self.songGenres = try container.decode([Audio.Details.Genres].self, forKey: Audio.Details.Artist.CodingKeys.songGenres)
        self.sortName = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.sortName)
        self.sourceID = try container.decode([Int].self, forKey: Audio.Details.Artist.CodingKeys.sourceID)
        self.style = try container.decode([String].self, forKey: Audio.Details.Artist.CodingKeys.style)
        self.type = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.type)
        self.yearsActive = try container.decode([String].self, forKey: Audio.Details.Artist.CodingKeys.yearsActive)
        self.art = try container.decode(Media.Artwork.self, forKey: Audio.Details.Artist.CodingKeys.art)
        self.dateAdded = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.dateAdded)
        self.genre = try container.decode([String].self, forKey: Audio.Details.Artist.CodingKeys.genre)
        self.fanart = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.fanart)
        self.thumbnail = try container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.thumbnail)
        
//        if let thumbnail = try? container.decode(String.self, forKey: Audio.Details.Artist.CodingKeys.thumbnail), !thumbnail.isEmpty {
//            self.thumbnail = Files.getFullPath(file: thumbnail, type: .art)
//        }
    }
}
