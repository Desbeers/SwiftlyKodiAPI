//
//  Setting+Section.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Setting {

    /// The  settings section (SwiftlyKodi Type)
    enum Section: String, Codable, Sendable {
        /// A section SwiftlyKodiAPI doesn't know about
        case unknown
        /// Interface section
        case interface
        /// Services section
        case services
        /// Player section
        case player
        /// Media section
        case media
    }
}
