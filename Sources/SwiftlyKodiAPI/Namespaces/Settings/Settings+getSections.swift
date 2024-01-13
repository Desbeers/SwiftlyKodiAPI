//
//  Settings+getSections.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getSections

extension Settings {

    /// Retrieves all setting sections (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All setting sections
    public static func getSections(host: HostItem) async -> [Setting.Details.Section] {
        let request = Settings.GetSections(host: host)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.sections.filter { $0.id != .unknown }
        } catch {
            Logger.kodiAPI.error("Getting sections failed with error: \(error)")
            return []
        }
    }

    /// Retrieves all setting sections (Kodi API)
    fileprivate struct GetSections: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .settingsGetSections
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(level: level))
        }
        /// The level
        let level: Setting.Level = .expert
        /// The parameters struct
        struct Params: Encodable {
            /// The settings level
            let level: Setting.Level
        }
        /// The response struct
        struct Response: Decodable {
            let sections: [Setting.Details.Section]
        }
    }
}
