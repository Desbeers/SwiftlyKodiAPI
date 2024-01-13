//
//  Addons+getAddons.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getAddons

extension Addons {

    /// Gets all available addons (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All addons from the Kodi host that have a known type for SwiflyKodiAPI
    /// 
    /// The result fill be filtered by 'known' ``Addon/Types``
    public static func getAddons(host: HostItem) async -> [Addon.Details] {
        let request = GetAddons(host: host)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.addons
                .filter { $0.addonType != .unknown }
        } catch {
            Logger.kodiAPI.error("Loading addons failed with error: \(error.localizedDescription)")
            return []
        }
    }

    /// Gets all available addons (Kodi API)
    fileprivate struct GetAddons: KodiAPI {
        /// The host
        let host: HostItem
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
