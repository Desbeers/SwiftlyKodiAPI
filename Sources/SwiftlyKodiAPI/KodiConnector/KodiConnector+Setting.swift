//
//  KodiConnector+Setting.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Get a Kodi Setting
    /// - Parameter id: The ID of the setting
    /// - Returns: The setting values
    public func getKodiSetting(id: Setting.ID) -> KodiSetting {
        if let setting = settings.first(where: { $0.id == id }) {
            return KodiSetting(
                bool: setting.settingBool?.value ?? false,
                list: setting.settingList?.value ?? []
            )
        }
        return KodiSetting()
    }

    /// Simplified struct for a kodi setting
    public struct KodiSetting {
        public var bool: Bool = false
        public var list: [Int] = []
    }
}
