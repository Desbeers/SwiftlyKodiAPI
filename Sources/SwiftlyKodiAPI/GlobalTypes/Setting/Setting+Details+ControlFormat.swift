//
//  Setting+Details+ControlFormat.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Control Format (SwiftlyKodi type)
    enum ControlFormat: String, Decodable, Sendable {
        case unknown
        case bool = "boolean"
        case int = "integer"
        case addon
        case action
        case string
        case path
        case percentage
        case ip
    }
}
