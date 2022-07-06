//
//  TVshows.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getTVShows

extension VideoLibrary {
    
    /// Get all the tv shows from the Kodi host
    /// - Returns: All movies from the Kodi host
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
    struct GetTVShows: KodiAPI {
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
    
    /// Get the details of a tv show
    /// - Parameter tvshowID: The ID of the tv show item
    /// - Returns: An updated Media Item
    public static func getTVShowDetails(tvshowID: Int) async -> MediaItem {
        let kodi: KodiConnector = .shared
        let request = GetTVShowDetails(tvshowID: tvshowID)
        do {
            let result = try await kodi.sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return kodi.setMediaItem(items: [result.tvshowdetails], media: .tvshow).first ?? MediaItem()
        } catch {
            logger("Loading tv show details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Retrieve details about a specific tv show (Kodi API)
    struct GetTVShowDetails: KodiAPI {
        /// Argument: the tv show we ask for
        var tvshowID: Int
        /// Method
        var method = Methods.videoLibraryGetTVShowDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.tvshowid = tvshowID
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.tvshow
            /// The ID of the episode
            var tvshowid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the tv show
            var tvshowdetails: KodiResponse
        }
    }
}

// MARK:  setTVShowDetails

extension VideoLibrary {
    
    /// Set the details of a tv show item
    ///
    /// - Note: Kodi does not send a notification if a TV show is changed
    ///
    /// - Parameter tvshow: The Media Item
    public static func setTVShowDetails(tvshow: MediaItem) async {
        let kodi: KodiConnector = .shared
        let message = SetTVShowDetails(tvshow: tvshow)
        Task {
            do {
                let _ = try await kodi.sendRequest(request: message)
                /// Update the TV show item
                kodi.getMediaItemDetails(itemID: tvshow.tvshowID, type: .tvshow)
                logger("Details set for '\(tvshow.title)'")
            } catch {
                logger("Setting TV show details failed with error: \(error)")
            }
        }
    }
    
    /// Update the given tv show with the given details (Kodi API)
    struct SetTVShowDetails: KodiAPI {
        /// Arguments
        var tvshow: MediaItem
        /// Method
        var method = Methods.videoLibrarySetTVShowDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters
            let params = Params(tvshow: tvshow)
            return buildParams(params: params)
        }
        /// The request struct
        /// - Note: The properties we want to set
        struct Params: Encodable {
            internal init(tvshow: MediaItem) {
                self.tvshowid = tvshow.tvshowID
                self.userrating = tvshow.rating
                self.playcount = tvshow.playcount
                self.lastplayed = tvshow.lastPlayed
            }
            /// The tv show ID
            var tvshowid: Int
            /// The rating
            var userrating: Int
            /// The playcount of the tv show
            var playcount: Int
            /// The last played date
            var lastplayed: String
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
