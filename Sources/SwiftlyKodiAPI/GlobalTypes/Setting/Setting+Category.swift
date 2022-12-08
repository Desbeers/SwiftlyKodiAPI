//
//  Setting+Category.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting {

    /// The  Category of the setting (SwiftlyKodi Type)
    enum Category: String, Codable {
        /// A category SwiftlyKodiAPI doesn't know about
        case unknown
        /// General category
        case general
        /// Music category
        case musicplayer
    }
}
