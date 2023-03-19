//
//  Settings+getSections.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getSections

extension Settings {

    /// Retrieves all setting sections (Kodi API)
    /// - Returns: All setting sections
    public static func getSections() async -> [Setting.Details.Section] {
        logger("Settings.GetSections")
        let kodi: KodiConnector = .shared
        let request = Settings.GetSections()
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.sections.filter { $0.id != .unknown }
        } catch {
            logger("Loading sections failed with error: \(error)")
            return []
        }
    }

    /// Retrieves all setting sections (Kodi API)
    fileprivate struct GetSections: KodiAPI {
        /// The level
        let level: Setting.Level = .expert
        /// The method
        let method: Method = .settingsGetSections
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
            let sections: [Setting.Details.Section]
        }
    }
}
