//
//  Settings+getSettings.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getSettings

extension Settings {
    
    /// Retrieves all settings (Kodi API)
    public static func getSettings() async -> [Setting.Details.Base] {
        logger("Settings.GetSettings")
        let kodi: KodiConnector = .shared
        let request = Settings.GetSettings()
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.settings.filter({$0.id != .unknown})
        } catch {
            logger("Loading settings failed with error: \(error)")
            return []
        }
    }
    
    /// Retrieves all settings (Kodi API)
    fileprivate struct GetSettings: KodiAPI {
        /// The level
        let level: Setting.Level = .expert
        /// The method
        let method: Methods = .settingsGetSettings
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(level: level))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The settings level
            let level: Setting.Level
        }
        /// The response struct
        struct Response: Decodable {
            let settings: [Setting.Details.Base]
        }
    }
}
