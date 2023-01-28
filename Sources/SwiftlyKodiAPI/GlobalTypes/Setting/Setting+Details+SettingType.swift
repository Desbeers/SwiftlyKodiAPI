//
//  Setting+Details+SettingType.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting Type (SwiftlyKodi type)
    enum SettingType: String, Decodable, Sendable {

        case unknown
        case bool = "boolean"
        case int = "integer"
        case string
        case list
        case addon
    }
}
