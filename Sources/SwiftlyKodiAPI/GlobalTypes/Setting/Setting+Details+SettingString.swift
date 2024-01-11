//
//  Setting+Details+SettingString.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting String (Global Kodi Type)
    struct SettingString: Decodable, Equatable, Sendable {

        public var value: String
        public var defaultValue: String
        public var allowEmpty: Bool
        public var options: [Option]?

        enum CodingKeys: String, CodingKey {
            case value
            case defaultValue = "default"
            case allowEmpty = "allowempty"
            case options
        }

        public struct Option: Hashable, Decodable, Sendable {
            public var label: String
            public var value: String

            enum CodingKeys: CodingKey {
                case label
                case value
            }
        }
    }
}
