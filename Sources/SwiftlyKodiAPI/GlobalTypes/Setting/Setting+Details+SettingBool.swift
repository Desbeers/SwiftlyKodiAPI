//
//  Setting+Details+SettingBool.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting Bool (Global Kodi Type)
    struct SettingBool: Decodable, Equatable, Sendable {

        public var value: Bool
        public var defaultValue: Bool

        enum CodingKeys: String, CodingKey {
            case value
            case defaultValue = "default"
        }
    }
}
