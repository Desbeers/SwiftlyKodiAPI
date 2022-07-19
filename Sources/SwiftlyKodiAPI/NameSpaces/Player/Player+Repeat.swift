//
//  Player+repeat.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

public extension Player {
    
    /// The repeat mode of the player (Global Kodi Type)
    enum Repeat: String, Decodable {
        /// Repeating is off
        case off = "off"
        /// Repeat the current item
        case one = "one"
        /// Repeat all items
        case all = "all"
    }
}
