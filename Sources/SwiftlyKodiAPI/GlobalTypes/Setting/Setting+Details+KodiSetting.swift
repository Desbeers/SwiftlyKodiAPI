//
//  KodiSetting+Details+Setting.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Setting  (Global Kodi Type)
    /// - Note: Renamed to `KodiSetting` because `Setting` is already in use
    struct KodiSetting: Decodable, Identifiable, Hashable {
        public var id: String { label }
        public var label: String
    }
}
