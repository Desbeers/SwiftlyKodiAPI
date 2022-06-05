//
//  TVshows.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Get all the TV shows from the Kodi host
    /// - Returns: All TV shows from the Kodi host
    func getTVShows() async -> [MediaItem] {
        let request = VideoLibraryGetTVShows()
        do {
            let result = try await sendRequest(request: request)
            return setMediaItem(items: result.tvshows, media: .tvshow)
        } catch {
            /// There are no TV shows in the library
            logger("Loading TV shows failed with error: \(error)")
            return [MediaItem]()
        }
    }
    
    /// Get the details of a tv show
    /// - Parameter tvshowID: The ID of the tv show item
    /// - Returns: An updated Media Item
    func getTVShowDetails(tvshowID: Int) async -> MediaItem {
        let request = VideoLibraryGetTVShowDetails(tvshowID: tvshowID)
        do {
            let result = try await sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return setMediaItem(items: [result.tvshowdetails], media: .tvshow).first ?? MediaItem()
        } catch {
            logger("Loading tv show details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Update the details of a tv show
    ///
    /// This method does not really work as expected,
    /// all episodes have to be checked and changed if needed
    /// and then the TV show must be reloaded.
    ///
    /// Kodi does not send a notification if a TV show is changed
    ///
    /// - Parameter tvshow: The Media Item
    func setTVShowDetails(tvshow: MediaItem) async {
        /// Get all episodes that don't match with the TV show playcount and match it
        var episodes = media.filter {
            $0.media == .episode &&
            $0.tvshowID == tvshow.tvshowID &&
            $0.playcount != tvshow.playcount
        }
        for (index, _) in episodes.enumerated() {
            episodes[index].togglePlayedState()
        }
        
        let message = VideoLibrarySetTVShowDetails(tvshow: tvshow)
        Task {
            do {
                let _ = try await sendRequest(request: message)
                /// Update the TV show item
                getMediaItemDetails(itemID: tvshow.tvshowID, type: .tvshow)
                logger("Details set for '\(tvshow.title)'")
            } catch {
                logger("Setting TV show details failed with error: \(error)")
            }
        }
        //sendMessage(message: message)
        //dump(await getTVShowDetails(tvshowID: tvshow.tvshowID))
        //logger("Details set for '\(tvshow.title)'")
    }
}

// MARK: Kodi API's

extension KodiConnector {
    
    /// The TV show properties we ask from Kodi
    static var videoFieldsTVShow = [
        "title",
        "sorttitle",
        "file",
        "plot",
        "genre",
        "art",
        "year",
        "premiered",
        "playcount",
        "dateadded",
        "studio",
        "episode",
        "lastplayed"
    ]
    
    /// Retrieve all TV shows (Kodi API)
    struct VideoLibraryGetTVShows: KodiAPI {
        /// Method
        var method = Method.videoLibraryGetTVShows
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.sort = sort(method: .title, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = videoFieldsTVShow
            /// The sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of TV shows
            let tvshows: [KodiResponse]
        }
    }
    
    /// Retrieve details about a specific tv show (Kodi API)
    struct VideoLibraryGetTVShowDetails: KodiAPI {
        /// Argument: the tv show we ask for
        var tvshowID: Int
        /// Method
        var method = Method.videoLibraryGetTVShowDetails
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
            let properties = KodiConnector.videoFieldsTVShow
            /// The ID of the episode
            var tvshowid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the tv show
            var tvshowdetails: KodiResponse
        }
    }
    
    /// Update the given tv show with the given details (Kodi API)
    struct VideoLibrarySetTVShowDetails: KodiAPI {
        /// Arguments
        var tvshow: MediaItem
        /// Method
        var method = Method.videoLibrarySetTVShowDetails
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
