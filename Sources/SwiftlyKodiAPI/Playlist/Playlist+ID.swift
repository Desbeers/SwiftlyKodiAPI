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
        /// The audio playlist
        case audio
        /// The video playlist
        case video
        /// The pictures playlist
        case piuctures
    }
}
