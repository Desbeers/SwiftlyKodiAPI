//
//  Setting+Details+Group.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Settings group  (Global Kodi Type)
    struct Group: Decodable, Identifiable, Hashable {
        public var id: String
        public var settings: [Setting.Details.KodiSetting]
    }
}
