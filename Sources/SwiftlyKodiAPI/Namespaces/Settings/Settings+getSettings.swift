//
//  Settings+getSettings.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getSettings

extension Settings {

    /// Retrieves all settings (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - section: Optional section
    ///   - category: Optional category
    /// - Returns: All settings, filtered by optional section and category
    /// - Note: Both must be nill or set or else it does not work
    public static func getSettings(
        host: HostItem,
        section: Setting.Section? = nil,
        category: Setting.Category? = nil
    ) async -> [Setting.Details.KodiSetting] {
        let request = Settings.GetSettings(host: host, section: section, category: category)
        do {
            let result = try await JSON.sendRequest(request: request)
            var knownSettings = result.settings.filter { $0.base.id != .unknown }
            /// Add optional addon settings
            let addons = await Addons.getAddons(host: host)
            knownSettings.indices.forEach { index in
                if knownSettings[index].settingType == .addon {
                    let options = addons.filter { $0.addonType == knownSettings[index].settingAddon?.addonType } .map { option in
                        Setting.Details.SettingAddon.Option(label: option.name, value: option.id)
                    }
                    knownSettings[index].settingAddon?.options.append(contentsOf: options)
                }
            }
            return knownSettings
        } catch {
            Logger.kodiAPI.error("Getting settings failed with error: \(error)")
            return []
        }
    }

    /// Retrieves all settings (Kodi API)
    private struct GetSettings: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .settingsGetSettings
        /// The parameters
        var parameters: Data {
            if let section, let category {
                return buildParams(params: Params(level: level, filter: Filter(section: section, category: category)))
            } else {
                return buildParams(params: Params(level: level, filter: nil))
            }
        }
        /// The optional section
        let section: Setting.Section?
        /// The optional category
        let category: Setting.Category?
        /// The level
        let level: Setting.Level = .expert
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
            let settings: [Setting.Details.KodiSetting]
        }
    }
}
