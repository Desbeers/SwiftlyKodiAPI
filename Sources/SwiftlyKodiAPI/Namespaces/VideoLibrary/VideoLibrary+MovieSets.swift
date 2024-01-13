//
//  VideoLibrary+MovieSets.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getMovieSets

extension VideoLibrary {

    /// Retrieve all movie sets (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All movie sets in an ``Video/Details/MovieSet`` array
    public static func getMovieSets(host: HostItem) async -> [Video.Details.MovieSet] {
        if let result = try? await JSON.sendRequest(request: GetMovieSets(host: host)) {
            Logger.library.info("Loaded \(result.sets.count) movie sets from the Kodi host")
            return result.sets
        }
        /// There are no movie sets in the library
        Logger.library.warning("There are no movie sets on the Kodi host")
        return [Video.Details.MovieSet]()
    }

    /// Retrieve all movie sets (Kodi API)
    fileprivate struct GetMovieSets: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.videoLibraryGetMovieSets
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

// MARK: getMovieSetDetails

extension VideoLibrary {

    /// Retrieve details about a specific movie set (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - setID: The movie set ID
    /// - Returns: All movie sets in an ``Video/Details/MovieSet`` array
    public static func getMovieSetDetails(host: HostItem, setID: Library.ID) async -> Video.Details.MovieSet {
        if let result = try? await JSON.sendRequest(request: GetMovieSetDetails(host: host, setID: setID)) {
            return result.setdetails
        }
        /// There are no movie sets in the library
        return Video.Details.MovieSet(media: .none)
    }

    /// Retrieve details about a specific movie set (Kodi API)
    fileprivate struct GetMovieSetDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.videoLibraryGetMovieSetDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(setID: setID))
        }
        /// The movie set ID
        let setID: Library.ID
        /// The parameters struct
        struct Params: Encodable {
            let setID: Library.ID
            /// The properties that we ask from Kodi
            let properties = Video.Fields.movieSet
            enum CodingKeys: String, CodingKey {
                case setID = "setid"
                case properties
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movie sets
            let setdetails: Video.Details.MovieSet
        }
    }
}
