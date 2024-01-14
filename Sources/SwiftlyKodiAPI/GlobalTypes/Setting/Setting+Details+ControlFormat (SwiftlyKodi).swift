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
        /// - Note: Not a Kodi value
        case unknown
        case boolean
        case integer
        case addon
        case action
        case string
        case path
        case percentage
        case ip
    }
}
