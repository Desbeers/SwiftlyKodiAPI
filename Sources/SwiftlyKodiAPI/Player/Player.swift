//
//  Player.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

enum PlayerID: Int, Decodable {
    /// The audio player
    case audio = 0
    /// The video player
    case video = 1
    /// The picture player
    case picture = 2
}
