//
//  Setting+Details+SettingInt.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting Int (Global Kodi Type)
    struct SettingInt: Decodable, Equatable, Sendable {

        public var value: Int
        public var defaultValue: Int
        public var maximum: Int?
        public var minimum: Int?
        public var step: Int?
        public var options: [Option]?

        enum CodingKeys: String, CodingKey {
            case value
            case defaultValue = "default"
            case maximum
            case minimum
            case step
            case options
        }
    }
}
