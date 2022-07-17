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
        /// The optional song ID
        var songid: Int?
        /// The optional music video ID
        var musicvideoid: Int?
        /// The optional file location of the item
        var file: String?
    }
}
