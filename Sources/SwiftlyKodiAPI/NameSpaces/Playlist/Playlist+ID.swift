//
//  Playlist+ID.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Playlist {
    
    /// The ID of the playlist (Global Kodi Type)
    enum ID: Int, Codable {
        /// No playlist
        case none = -1
        /// The audio playlist
        case audio = 0
        /// The video playlist
        case video = 1
        /// The pictures playlist
        case pictures = 2
    }
}
