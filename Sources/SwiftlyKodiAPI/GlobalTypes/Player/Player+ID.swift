//
//  Player+ID.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

public extension Player {
    
    /// The ID of the player (Global Kodi Type)
    enum ID: Int, Codable {
        
        /// # Player.Id
        
        /// The audio player
        case audio
        /// The video player
        case video
        /// The picture player
        case picture
    }
}
