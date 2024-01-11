//
//  Setting+Level.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting {

    /// The settings level (Global Kodi Type)
    enum Level: String, Codable {

        /// # Setting.Level

        case basic
        case standard
        case advanced
        case expert
    }
}
