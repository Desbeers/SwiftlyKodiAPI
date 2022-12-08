//
//  Setting+Section.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting {

    /// The  settings section (SwiftlyKodi Type)
    enum Section: String, Codable {
        /// A section SwiftlyKodiAPI doesn't know about
        case unknown
        /// Services section
        case services
        /// Player section
        case player
    }
}
