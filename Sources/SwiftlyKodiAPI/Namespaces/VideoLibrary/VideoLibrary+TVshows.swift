//
//  VideoLibrary+TVshows.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getTVShows

extension VideoLibrary {

    /// Retrieve all TV shows (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All TV shows in an ``Video/Details/TVShow`` array
    public static func getTVShows(host: HostItem) async -> [Video.Details.TVShow] {
        if let result = try? await JSON.sendRequest(request: GetTVShows(host: host)) {
            Logger.library.info("Loaded \(result.tvshows.count) TV shows from the Kodi host")
            return result.tvshows
        }
        /// There are no TV shows in the library
        Logger.library.warning("There are no TV shows on the Kodi host")
        return [Video.Details.TVShow]()
    }

    /// Retrieve all TV shows (Kodi API)
    fileprivate struct GetTVShows: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        var method = Method.videoLibraryGetTVShows
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The Params struct
        struct Params: Encodable {
            /// The properties
            let properties = Video.Fields.tvshow
            /// The sorting
            let sort = List.Sort(method: .sortTitle, order: .ascending)
        }
        /// The Response struct
        struct Response: Decodable {
            /// The list of TV shows
            let tvshows: [Video.Details.TVShow]
        }
    }
}

// MARK: getTVShowDetails

extension VideoLibrary {

    /// Retrieve details about a specific tv show (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - tvshowID: The ID of the TV show
    /// - Returns: A ``Video/Details/TVShow`` Item
    public static func getTVShowDetails(host: HostItem, tvshowID: Library.ID) async -> Video.Details.TVShow {
        let request = GetTVShowDetails(host: host, tvshowID: tvshowID)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.tvshowdetails
        } catch {
            Logger.kodiAPI.error("Loading tv show details failed with error: \(error)")
            return Video.Details.TVShow(media: .none)
        }
    }

    /// Retrieve details about a specific tv show (Kodi API)
    fileprivate struct GetTVShowDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        var method = Method.videoLibraryGetTVShowDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(tvshowID: tvshowID))
        }
        /// The tv show ID
        var tvshowID: Library.ID
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.tvshow
            /// The ID of the tv show
            let tvshowID: Library.ID
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case properties
                case tvshowID = "tvshowid"
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the tv show
            var tvshowdetails: Video.Details.TVShow
        }
    }
}

// MARK: setTVShowDetails

extension VideoLibrary {

    /// Update the given tv show with the given details (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - tvshow: The ``Video/Details/TVShow`` Item
    /// - Note: Kodi does not send a notification if a TV show is changed
    public static func setTVShowDetails(host: HostItem, tvshow: Video.Details.TVShow) async {
        let message = SetTVShowDetails(host: host, tvshow: tvshow)
        JSON.sendMessage(message: message)
        Logger.library.notice("Details set for '\(tvshow.title)'")
    }

    /// Update the given tv show with the given details (Kodi API)
    fileprivate struct SetTVShowDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        var method = Method.videoLibrarySetTVShowDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(tvshow: tvshow))
        }
        /// The TV show
        var tvshow: Video.Details.TVShow
        /// The parameters struct
        struct Params: Encodable {
            /// Init the params
            init(tvshow: Video.Details.TVShow) {
                self.tvshowID = tvshow.tvshowID
                self.userRating = tvshow.userRating
                self.playcount = tvshow.playcount
                self.lastPlayed = tvshow.lastPlayed
            }
            /// The tv show ID
            let tvshowID: Library.ID
            /// The rating
            let userRating: Int
            /// The playcount of the tv show
            let playcount: Int
            /// The last played date
            let lastPlayed: String
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case tvshowID = "tvshowid"
                case userRating = "userrating"
                case playcount
                case lastPlayed = "lastplayed"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
