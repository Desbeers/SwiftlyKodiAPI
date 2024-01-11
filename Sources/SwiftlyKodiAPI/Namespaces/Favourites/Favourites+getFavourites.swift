//
//  Favourites+getFavourites.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

extension Favourites {

    /// Retrieve all favourites (Kodi API)
    /// - Returns: All favourites
    public static func getFavourites() async -> [Favourite.Details.Favourite] {
        let kodi: KodiConnector = .shared
        let request = GetFavourites()
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.favourites
        } catch {
            /// There are no favorites
            Logger.library.info("There are no favorites on '\(kodi.host.name)'")
            return []
        }
    }

    /// Retrieve all favourites (Kodi API)
    fileprivate struct GetFavourites: KodiAPI {
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
