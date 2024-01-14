//
//  Setting+Details+SettingList.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting List (Global Kodi Type)
    struct SettingList: Decodable, Equatable, Sendable {
        public var value: [Int] = []
        public var defaultValue: [Int] = []
        public var options: [Option] = []

        enum CodingKeys: String, CodingKey {
            case value
            case defaultValue = "default"

            /// The 'definition' container
            case definition
        }

        /// The Coding Keys for a Definition
        enum Definition: String, CodingKey {
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

public extension Setting.Details.SettingList {

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        self.value = try container.decode([Int].self, forKey: .value)
        self.defaultValue = try container.decode([Int].self, forKey: .defaultValue)

        if let definition = try? container.nestedContainer(keyedBy: Definition.self, forKey: .definition) {
            self.options = try definition.decode([Option].self, forKey: .options)
        }
    }
}
