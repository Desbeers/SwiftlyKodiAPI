//
//  Favourites+getFavourites.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Favourites {

    /// Retrieve all favourites (Kodi API)
    /// - Returns: All favourites
    public static func getFavourites() async -> [Favourite.Details.Favourite] {
        logger("Favourites.GetFavourites")
        let kodi: KodiConnector = .shared
        let request = GetFavourites()
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.favourites
        } catch {
            logger("Loading favourites failed with error: \(error)")
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
            let properties = ["path", "window", "windowparameter"]
        }
        /// The response struct
        struct Response: Decodable {
            let favourites: [Favourite.Details.Favourite]
        }
    }
}
