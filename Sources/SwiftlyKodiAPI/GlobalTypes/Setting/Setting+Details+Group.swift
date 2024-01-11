//
//  Setting+Details+Group.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Settings group  (Global Kodi Type)
    struct Group: Decodable, Identifiable, Hashable, Sendable {
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        /// The ID of the setting
        public var id: String
        public var settings: [KodiSetting]

        enum CodingKeys: CodingKey {
            case id
            case settings
        }

        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(String.self, forKey: .id)
            let settings = try container.decode([Setting.Details.KodiSetting].self, forKey: .settings)
            /// Only show 'root' settings we know about
            self.settings = settings.filter { $0.settingType != .unknown && $0.parent == .none }
        }
    }
}
