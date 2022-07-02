//
//  LibraryItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public struct LibraryItem: Codable {
    public var id: Int { artistID }
    
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
}

extension LibraryItem {
//    /// # Top-level coding keys
//    enum CodingKeys: String, CodingKey {
//        case artists
//    }
}

extension LibraryItem {
    public init(from decoder: Decoder) throws {
        
        
        logger("DECODE ARTISTS")
        /// # Top-level coding keys
        enum CodingKeys: String, CodingKey {
            case artists
        }
        /// # Top level
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //dump(container)
//        /// # Top level
//
//        if let artists = try container.nestedContainer(keyedBy: Audio.Details.Artist.CodingKeys.self, forKey: .artists) {
//
//        }
        
        //let container = try decoder.container
        //let container = try decoder.container(keyedBy: CodingKeys.self)
    }
}
