//
//  Files+MediaType.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Files {

    /// The type of media; either an image or a file (SwiftlyKodi Type)
    ///
    /// - Note: This enum is used to convert an internal Kodi path to a full path
    enum MediaType: String {
        /// An image; poster, fanart etc...
        case art = "image"
        /// A file, either video or audio
        case file = "vfs"
    }
}
