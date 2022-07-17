//
//  Player+Subtitle.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Player {
    
    /// The current subtitle of the player (Global Kodi Type)
    struct Subtitle: Decodable {
        public var index: Int = 0
        public var isDefault: Bool = false
        public var isForced: Bool = false
        public var isImpaired: Bool = false
        public var language: String = ""
        public var name: String = ""
        enum CodingKeys: String, CodingKey {
            case index
            case isDefault = "isdefault"
            case isForced = "isforced"
            case isImpaired = "isimpaired"
            case language, name
        }
    }
}
