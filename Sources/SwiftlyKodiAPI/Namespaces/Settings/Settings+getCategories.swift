//
//  Settings+getCategories.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getCategories

extension Settings {

    /// Retrieves all setting categories (Kodi API)
    /// - Parameter section: The section for the categories
    /// - Returns: All categories from the selected section
    public static func getCategories(section: Setting.Section) async -> [Setting.Details.Category] {
        logger("Settings.GetCategories")
        let kodi: KodiConnector = .shared
        let request = Settings.GetCategories(section: section)
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.categories.filter({$0.id != .unknown})
        } catch {
            logger("Loading categories failed with error: \(error)")
            return []
        }
    }
    
    /// Retrieves all setting categories (Kodi API)
    fileprivate struct GetCategories: KodiAPI {
        /// The level
        let level: Setting.Level = .expert
        /// The Section
        let section: Setting.Section
        /// The method
        let method: Methods = .settingsGetCategories
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(level: level, section: section))
        }
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
