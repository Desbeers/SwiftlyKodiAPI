//
//  Setting+Details+SettingList.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Setting List (Global Kodi Type)
    struct SettingList: Decodable {
        public var label: String = ""
        public var value: Int = -1
        
    }
}
