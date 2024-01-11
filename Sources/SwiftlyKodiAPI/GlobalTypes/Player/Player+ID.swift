//
//  Player+ID.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

public extension Player {

    // swiftlint:disable type_name
    /// The ID of the player (Global Kodi Type)
    enum ID: Int, Codable, Sendable {

        /// # Player.Id

        /// The audio player
        case audio
        /// The video player
        case video
        /// The picture player
        case picture
    }
    // swiftlint:enable type_name
}
