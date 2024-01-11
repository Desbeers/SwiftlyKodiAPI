//
//  Addon+Details.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Addon {

    /// Addon details {Global Kodi Type)
    struct Details: Decodable {
        /// The ID of the addon
        public var id: String = ""
        /// The name of the addon
        public var name: String = ""
        /// The type of addon
        public var addonType: Addon.Types = .unknown
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case addonID = "addonid"
            case name
            case addonType = "type"
        }
        /// Custom decoder
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            let addonType = try container.decode(String.self, forKey: .addonType)
            /// Only decode addon types we know about
            if let addonType = Addon.Types(rawValue: addonType) {
                self.id = try container.decode(String.self, forKey: .addonID)
                self.name = try container.decode(String.self, forKey: .name)
                self.addonType = addonType
            }
        }
    }
}
