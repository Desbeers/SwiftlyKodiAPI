//
//  Player+repeat.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

public extension Player {

    /// The repeat mode of the player (Global Kodi Type)
    enum Repeat: String, Decodable {

        /// # Player.Repeat

        /// Repeating is off
        case off
        /// Repeat the current item
        case one
        /// Repeat all items
        case all
    }
}
