//
//  Setting+Details+Group.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Settings group  (Global Kodi Type)
    struct Group: Decodable, Identifiable, Hashable, Sendable {
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        public var id: String
        public var settings: [KodiSetting]

        enum CodingKeys: CodingKey {
            case id
            case settings
        }

        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Setting.Details.Group.CodingKeys> = try decoder.container(keyedBy: Setting.Details.Group.CodingKeys.self)

            self.id = try container.decode(String.self, forKey: Setting.Details.Group.CodingKeys.id)
            let settings = try container.decode([Setting.Details.KodiSetting].self, forKey: Setting.Details.Group.CodingKeys.settings)
            /// Only show 'root' settings we know about
            self.settings = settings.filter({$0.settingType != .unknown && $0.parent == .none})

        }

//        public struct KodiSetting: Decodable, Identifiable, Hashable {
//            public var id: String { label }
//            public var label: String
//        }
    }
}
