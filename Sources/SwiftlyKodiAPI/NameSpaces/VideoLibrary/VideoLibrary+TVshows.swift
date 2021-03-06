//
//  VideoLibrary+TVshows.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getTVShows

extension VideoLibrary {
    
    /// Retrieve all TV shows (Kodi API)
    /// - Returns: All TV shows in an ``Video/Details/TVShow`` array
    public static func getTVShows() async -> [Video.Details.TVShow] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetTVShows()) {
            logger("Loaded \(result.tvshows.count) TV shows from the Kodi host")
            return result.tvshows
        }
        /// There are no TV shows in the library
        return [Video.Details.TVShow]()
    }
    
    /// Retrieve all TV shows (Kodi API)
    fileprivate struct GetTVShows: KodiAPI {
        /// The method
        var method = Methods.videoLibraryGetTVShows
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

// MARK:  getTVShowDetails

extension VideoLibrary {
    
    /// Retrieve details about a specific tv show (Kodi API)
    /// - Parameter tvshowID: The ID of the TV show
    /// - Returns: A ``Video/Details/TVShow`` Item
    public static func getTVShowDetails(tvshowID: Library.id) async -> Video.Details.TVShow {
        let kodi: KodiConnector = .shared
        let request = GetTVShowDetails(tvshowID: tvshowID)
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.tvshowdetails
        } catch {
            logger("Loading tv show details failed with error: \(error)")
            return Video.Details.TVShow()
        }
    }
    
    /// Retrieve details about a specific tv show (Kodi API)
    fileprivate struct GetTVShowDetails: KodiAPI {
        /// The tv show ID
        var tvshowID: Library.id
        /// The method
        var method = Methods.videoLibraryGetTVShowDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(tvshowID: tvshowID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.tvshow
            /// The ID of the tv show
            let tvshowID: Library.id
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

// MARK:  setTVShowDetails

extension VideoLibrary {
    
    /// Update the given tv show with the given details (Kodi API)
    ///
    /// - Note: Kodi does not send a notification if a TV show is changed
    ///
    /// - Parameter tvshow: The ``Video/Details/TVShow`` Item
    public static func setTVShowDetails(tvshow: Video.Details.TVShow) async {
        let kodi: KodiConnector = .shared
        let message = SetTVShowDetails(tvshow: tvshow)
        kodi.sendMessage(message: message)
        logger("Details set for '\(tvshow.title)'")
    }
    
    /// Update the given tv show with the given details (Kodi API)
    fileprivate struct SetTVShowDetails: KodiAPI {
        /// The TV show
        var tvshow: Video.Details.TVShow
        /// The method
        var method = Methods.videoLibrarySetTVShowDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(tvshow: tvshow))
        }
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
            let tvshowID: Library.id
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
