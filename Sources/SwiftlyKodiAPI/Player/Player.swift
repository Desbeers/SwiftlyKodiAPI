//
//  File.swift
//  
//
//  Created by Nick Berendsen on 12/03/2022.
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
