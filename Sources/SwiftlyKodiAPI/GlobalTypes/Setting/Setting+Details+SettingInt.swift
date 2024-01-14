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

        public var value: Int = -1
        public var defaultValue: Int = -1
        public var maximum: Int = -1
        public var minimum: Int = -1
        public var step: Int = -1
        public var options: [Option] = []

        enum CodingKeys: String, CodingKey {
            case value
            case defaultValue = "default"
            case maximum
            case minimum
            case step
            case options
        }

        public struct Option: Hashable, Decodable, Sendable {
            public var label: String = ""
            public var value: Int = -1
            
            enum CodingKeys: CodingKey {
                case label
                case value
            }
        }
    }
}

public extension Setting.Details.SettingInt {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Setting.Details.SettingInt.CodingKeys> = try decoder.container(keyedBy: Setting.Details.SettingInt.CodingKeys.self)
        self.value = try container.decode(Int.self, forKey: .value)
        self.defaultValue = try container.decode(Int.self, forKey: .defaultValue)
        self.maximum = try container.decodeIfPresent(Int.self, forKey: .maximum) ?? self.maximum
        self.minimum = try container.decodeIfPresent(Int.self, forKey: .minimum) ?? self.minimum
        self.step = try container.decodeIfPresent(Int.self, forKey: .step) ?? self.step
        self.options = try container.decodeIfPresent([Option].self, forKey: .options) ?? self.options
    }
}
