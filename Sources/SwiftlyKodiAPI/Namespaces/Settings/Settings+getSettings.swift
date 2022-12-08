//
//  Settings+getSettings.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: getSettings

extension Settings {

    /// Retrieves all settings (Kodi API)
    /// - Parameters:
    ///   - section: Optional section
    ///   - category: Optional category
    ///
    /// - Note: Both must be nill or set or else it does not work
    ///
    /// - Returns: All settings, filtered by optional section and category
    public static func getSettings(section: Setting.Section? = nil, category: Setting.Category? = nil) async -> [Setting.Details.Base] {
        logger("Settings.GetSettings")
        let kodi: KodiConnector = .shared
        let request = Settings.GetSettings(section: section, category: category)
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
        /// The optional section
        let section: Setting.Section?
        /// The optional category
        let category: Setting.Category?
        /// The level
        let level: Setting.Level = .expert
        /// The method
        let method: Methods = .settingsGetSettings
        /// The parameters
        var parameters: Data {
            if let section, let category {
                return buildParams(params: Params(level: level, filter: Filter(section: section, category: category)))
            } else {
                return buildParams(params: Params(level: level, filter: nil))
            }
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The settings level
            let level: Setting.Level
            /// The optional filter
            let filter: Filter?
        }
        /// The optional filter struct
        struct Filter: Encodable {
            let section: Setting.Section?
            let category: Setting.Category?
        }
        /// The response struct
        struct Response: Decodable {
            let settings: [Setting.Details.Base]
        }
    }
}
