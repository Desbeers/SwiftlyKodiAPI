//
//  Setting+Level.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting {
    
    /// The settings level
    enum Level: String, Codable {
        case basic
        case standard
        case advanced
        case expert
    }
}
