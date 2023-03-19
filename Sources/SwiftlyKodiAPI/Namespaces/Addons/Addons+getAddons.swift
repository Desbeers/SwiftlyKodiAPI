//
//  Addons+getAddons.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getAddons

extension Addons {

    /// Gets all available addons (Kodi API)
    ///
    /// - The result fill be filtered by 'known' ``Addon/Types``
    ///
    /// - Returns: All addons from the Kodi host that have a known type for SwiflyKodiAPI
    public static func getAddons() async -> [Addon.Details] {
        logger("Addons.GetAddons")
        let kodi: KodiConnector = .shared
        let request = GetAddons()
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.addons
                .filter { $0.addonType != .unknown }
        } catch {
            logger("Loading addons failed with error: \(error)")
            return []
        }
    }

    /// Gets all available addons (Kodi API)
    fileprivate struct GetAddons: KodiAPI {
        /// The method
        let method: Method = .addonsGetAddons
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties
            let properties = ["name"]
        }
        /// The response struct
        struct Response: Decodable {
            let addons: [Addon.Details]
        }
    }
}
