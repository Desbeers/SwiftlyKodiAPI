//
//  Player+repeat.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

public extension Player {

    /// The repeat mode of the player (Global Kodi Type)
    enum Repeat: String, Decodable, Sendable {

        /// # Player.Repeat

        /// Repeating is off
        case off
        /// Repeat the current item
        case one
        /// Repeat all items
        case all
    }
}
