//
//  Setting+Type.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting {

    /// Setting Type (Global Kodi Type)
    /// - Note: Kodi calls this `Type` but that is a reserved word
    enum SettingType: String, Decodable, Sendable {
        /// - Note: Not a Kodi value
        case unknown
        case boolean
        case integer
        case number
        case string
        case action
        case list
        case path
        case addon
        case date
        case time
    }
}
