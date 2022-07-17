//
//  Playlist+Item.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Playlist {
    
    struct Item: Encodable {
        var songid: Int?
        var file: String?
    }
}
