//
//  Player+PartyMode.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

public extension Player {

    /// Party mode of the player (SwiftlyKodi Type)
    enum PartyMode: String, Encodable {
        /// Music party
        case music
        /// Video party
        case video
    }
}
