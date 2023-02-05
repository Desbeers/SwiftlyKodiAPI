//
//  Files+Media.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Files {

    /// The kind of media for ``Files`` (Global Kodi Type)
    enum Media: String, Codable, Sendable {
        /// Video items
        case video
        /// Music items
        case music
        /// Picture items
        case pictures
        /// File items
        case files
        /// Programm items
        case programs
    }
}
