//
//  Player+GoToAction.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

public extension Player {
    
    /// The action for ``goTo(playerID:action:)`` (SwiftlyKodi Type)
    enum GoToAction: String, Codable {
        /// Goto the previous item
        case previous = "previous"
        /// Goto the next item
        case next = "next"
    }
}
