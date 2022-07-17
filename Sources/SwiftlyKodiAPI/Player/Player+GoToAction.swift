//
//  Player+GoToAction.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

public extension Player {
    
    /// The action for  the player (SwiftlyKodi API)
    /// - Note: Custom enum, Kodi does not have this
    enum GoToAction: String, Codable {
        /// Goto the previous item
        case previous = "previous"
        /// Goto the next item
        case next = "next"
    }
}
