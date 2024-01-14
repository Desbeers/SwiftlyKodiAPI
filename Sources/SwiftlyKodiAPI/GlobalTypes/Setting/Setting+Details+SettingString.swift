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

        public var value: String = ""
        public var defaultValue: String = ""
        public var allowEmpty: Bool = false
        public var options: [Option] = []

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

public extension Setting.Details.SettingString {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Setting.Details.SettingString.CodingKeys> = try decoder.container(keyedBy: Setting.Details.SettingString.CodingKeys.self)
        self.value = try container.decode(String.self, forKey: .value)
        self.defaultValue = try container.decode(String.self, forKey: .defaultValue)
        self.allowEmpty = try container.decode(Bool.self, forKey: .allowEmpty)
        self.options = try container.decodeIfPresent([Option].self, forKey: .options) ?? self.options
    }
}
