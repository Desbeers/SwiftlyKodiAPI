//
//  Setting+Details+Section.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Settings section  (Global Kodi Type)
    struct Section: Decodable, Identifiable, Hashable {
        
        /// # Setting.Details.Base
        
        public var id: Setting.Section = .unknown
        public var label: String = ""
        public var help: String = ""
        
        /// # Coding keys
        
        enum CodingKeys: String, CodingKey {
            case sectionID = "id"
            case label
            case help
        }
    }
}

extension Setting.Details.Section {
    
    /// Custom decoder
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        let settingID = try container.decode(String.self, forKey: CodingKeys.sectionID)
        /// Only decode sections we know about
        if let sectionID = Setting.Section(rawValue: settingID) {
            self.id = sectionID
            self.label = try container.decode(String.self, forKey: CodingKeys.label)
            self.help = try container.decode(String.self, forKey: CodingKeys.help)
        }
    }
}
