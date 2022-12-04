//
//  Playlist+Item.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Playlist {
    
    /// An item in a playlist (Global Kodi Type)
    struct Item: Encodable {
        
        /// # Playlist.Item
        
        /// The optional song ID
        var songID: Library.id?
        /// The optional music video ID
        var musicVideoID: Library.id?
        /// The optional file location of the item
        var file: String?
        
        /// # Coding keys
        
        enum CodingKeys: String, CodingKey {
            case songID = "songid"
            case musicVideoID = "musicvideoid"
            case file
        }
    }
}
