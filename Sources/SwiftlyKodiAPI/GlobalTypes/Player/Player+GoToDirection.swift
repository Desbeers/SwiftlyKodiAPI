//
//  Player+GoToDirection.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

public extension Player {

    /// The direction for ``goTo(playerID:position:)`` (SwiftlyKodi Type)
    enum GoToDirection: String, Codable {
        /// Goto the previous item
        case previous
        /// Goto the next item
        case next
    }
}
