//
//  Favourites+getFavourites.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getFavourites

extension Favourites {

    /// Retrieve all favourites (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All favourites
    public static func getFavourites(host: HostItem) async -> [Favourite.Details.Favourite] {
        let request = GetFavourites(host: host)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.favourites
        } catch {
            /// There are no favorites
            Logger.library.info("There are no favorites on '\(host.name)'")
            return []
        }
    }

    /// Retrieve all favourites (Kodi API)
    fileprivate struct GetFavourites: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .favouritesGetFavourites
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
        struct Params: Encodable {
            let properties = ["path", "window", "windowparameter", "thumbnail"]
        }
        /// The response struct
        struct Response: Decodable {
            let favourites: [Favourite.Details.Favourite]
        }
    }
}
