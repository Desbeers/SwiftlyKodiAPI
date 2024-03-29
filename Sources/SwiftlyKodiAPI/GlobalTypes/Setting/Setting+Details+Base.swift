//
//  Setting+Details+Base.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

/// # Setting.Details.Base

extension Setting.Details {

    /// Setting Details Base (Global Kodi Type)
    struct Base: Decodable, Equatable {
        /// The ID of the setting
        public var id: Setting.ID = .unknown
        /// The label of the setting
        public var label: String = ""
        /// Optional help of the setting
        public var help: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case settingID = "id"
            case label
            case help
        }
    }
}

extension Setting.Details.Base {

    /// # Init

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        let settingID = try container.decode(String.self, forKey: .settingID)
        /// Only decode settings we know about
        if let settingID = Setting.ID(rawValue: settingID) {
            self.id = settingID
            self.label = try container.decode(String.self, forKey: .label)
            self.help = try container.decodeIfPresent(String.self, forKey: .help) ?? self.help
        }
    }
}
