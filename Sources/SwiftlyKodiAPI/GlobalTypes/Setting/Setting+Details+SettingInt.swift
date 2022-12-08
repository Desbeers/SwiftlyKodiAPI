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

        /// # Setting.Details.Base

        public var label: String = ""

        /// # Setting.Details.SettingInt

        public var value: Int
    }
}
