//
//  VideoLibrary+MovieSets.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: getMovieSets

extension VideoLibrary {
    
    /// Retrieve all movie sets (Kodi API)
    /// - Returns: All movie sets in an ``Video/Details/MovieSet`` array
    public static func getMovieSets() async -> [Video.Details.MovieSet] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetMovieSets()) {
            logger("Loaded \(result.sets.count) movie sets from the Kodi host")
            return result.sets
        }
        /// There are no movie sets in the library
        return [Video.Details.MovieSet]()
    }
    
    /// Retrieve all movie sets (Kodi API)
    fileprivate struct GetMovieSets: KodiAPI {
        /// The method
        let method = Methods.videoLibraryGetMovieSets
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.movieSet
            /// The sort order
            let sort = List.Sort(method: .title, order: .ascending)
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movie sets
            let sets: [Video.Details.MovieSet]
        }
    }
}
