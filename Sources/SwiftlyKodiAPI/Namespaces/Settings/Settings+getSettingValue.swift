//
//  Settings+getSettingValue.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: setSettingValue

extension Settings {

    /// Retrieves the value of a setting (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - setting: The ``Setting/ID`` to receive
    /// - Returns: The values of the setting
    public static func getSettingValue(
        host: HostItem,
        setting: Setting.ID
    ) async -> Setting.Value.Extended {
        let request = GetSettingValue(host: host, setting: setting)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result
        } catch {
            Logger.kodiAPI.error("Loading setting failed with error: \(error)")
            return Setting.Value.Extended()
        }

    }

    /// Retrieves the value of a setting (Kodi API)
    fileprivate struct GetSettingValue: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .settingsGetSettingValue
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(setting: setting.rawValue))
        }
        /// The ``Setting/ID`` to get
        let setting: Setting.ID
        /// The parameters struct
        struct Params: Encodable {
            /// The setting
            let setting: String
        }
        /// The response struct
        typealias Response = Setting.Value.Extended
    }
}
