//
//  Setting+Details+SettingInt.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Setting Int (Global Kodi Type)
    struct SettingInt: Hashable, Decodable {
        public var label: String = ""
        public var value: Int
        
//        enum CodingKeys: CodingKey {
//            case label
//            //case value
//        }
        
        
//        public init(from decoder: Decoder) throws {
//            let container: KeyedDecodingContainer<Setting.Details.SettingInt.CodingKeys> = try decoder.container(keyedBy: Setting.Details.SettingInt.CodingKeys.self)
//            
//            self.label = try container.decode(String.self, forKey: Setting.Details.SettingInt.CodingKeys.label)
//            
//            if let value = try? container.decodeIfPresent(Int.self, forKey: Setting.Details.SettingInt.CodingKeys.value) {
//                self.value = value
//            }
//            
//            //self.value = try container.decodeIfPresent(Int.self, forKey: Setting.Details.Option.CodingKeys.value)
//            
//        }
        
        
    }
}
