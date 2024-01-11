//
//  Player+MediaType.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Player {

    /// The type of player (SwiftlyKodi Type)
    enum MediaType: String, Decodable {
        /// No active player
        case none
        /// The audio player
        case audio
        /// The video player
        case video
        /// The picture player
        case picture
    }
}
