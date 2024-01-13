//
//  Setting+Details+SettingAddon.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting Addon (Global Kodi Type)
    struct SettingAddon: Decodable, Equatable, Sendable {

        public var addonType: Addon.Types

        public var value: String
        public var defaultValue: String
        public var allowEmpty: Bool
        public var options: [Option] = []

        enum CodingKeys: String, CodingKey {
            case addonType = "addontype"
            case value
            case defaultValue = "default"
            case allowEmpty = "allowempty"
        }

        public struct Option: Hashable, Decodable, Sendable {
            public var label: String
            public var value: String

            enum CodingKeys: CodingKey {
                case label
                case value
            }
        }
        
        /// Init the addon settings
        /// - Note: The options will be filled by the `Settings.getSettings` function
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.addonType = try container.decode(Addon.Types.self, forKey: .addonType)
            self.value = try container.decode(String.self, forKey: .value)
            self.defaultValue = try container.decode(String.self, forKey: .defaultValue)
            self.allowEmpty = try container.decode(Bool.self, forKey: .allowEmpty)
        }
    }
}
