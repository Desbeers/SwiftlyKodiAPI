//
//  Player+ID.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

public extension Player {
    
    /// The ID of the player (Global Kodi Type)
    enum ID: Int, Codable {
        /// The audio player
        case audio = 0
        /// The video player
        case video = 1
        /// The picture player
        case picture = 2
    }
}
