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
    public func getKodiSetting(id: Setting.ID) -> Setting.Details.Setting {
        guard
            let setting = settings.first(where: { $0.id == id })
        else {
            /// This should not happen
            fatalError()
        }
        return setting
    }
}
