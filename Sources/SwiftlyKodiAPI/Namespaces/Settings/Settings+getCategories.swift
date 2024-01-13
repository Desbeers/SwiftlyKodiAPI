//
//  Settings+getCategories.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getCategories

extension Settings {

    /// Retrieves all setting categories (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - section: The section for the categories
    /// - Returns: All categories from the selected section
    public static func getCategories(host: HostItem, section: Setting.Section) async -> [Setting.Details.Category] {
        let request = Settings.GetCategories(host: host, section: section)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.categories.filter { $0.id != .unknown }
        } catch {
            Logger.kodiAPI.error("Getting categories failed with error: \(error)")
            return []
        }
    }

    /// Retrieves all setting categories (Kodi API)
    fileprivate struct GetCategories: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .settingsGetCategories
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(level: level, section: section))
        }
        /// The level
        let level: Setting.Level = .expert
        /// The section
        let section: Setting.Section
        /// The parameters struct
        struct Params: Encodable {
            /// The settings level
            let level: Setting.Level
            /// The settings section
            let section: Setting.Section

            let properties = ["settings"]
        }
        /// The response struct
        struct Response: Decodable {
            let categories: [Setting.Details.Category]
        }
    }
}
