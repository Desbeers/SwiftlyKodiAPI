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
        
        /// # Setting.Details.Base
        
        public var label: String = ""
        
        /// # Setting.Details.SettingList
        
        public var value: Int = -1
        
    }
}
