//
//  Setting+Details+Category.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting category  (Global Kodi Type)
    struct Category: Decodable, Identifiable, Hashable {

        /// # Setting.Details.Base

        public var id: Setting.Category = .unknown
        public var label: String = ""
        /// Help is optional
        public var help: String?
        public var groups: [Setting.Details.Group] = []

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case categoryID = "id"
            case label
            case help
            case groups
        }
    }
}

extension Setting.Details.Category {

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        let categoryID = try container.decode(String.self, forKey: CodingKeys.categoryID)
        /// Only decode categories we know about
        if let categoryID = Setting.Category(rawValue: categoryID) {
            self.id = categoryID
            self.label = try container.decode(String.self, forKey: CodingKeys.label)
            self.help = try container.decodeIfPresent(String.self, forKey: CodingKeys.help)
            self.groups = try container.decode([Setting.Details.Group].self, forKey: CodingKeys.groups)
        }

    }

}
