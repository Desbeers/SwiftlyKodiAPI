//
//  Setting+Category.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting {

    /// The category of the setting (SwiftlyKodi Type)
    enum Category: String, Codable, Sendable {
        /// A category SwiftlyKodiAPI doesn't know about
        case unknown
        /// General category
        case general
        /// Video category
        case videoplayer
        /// Music category
        case musicplayer
        /// Video category
        case video
        /// File lists category
        case filelists
        /// Skin category
        case skin
        /// Regional category
        case regional
    }
}
