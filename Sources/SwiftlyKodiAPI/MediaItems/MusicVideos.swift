//
//  MusicVideos.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Get all the music videos from the Kodi host
    /// - Returns: All music videos from the Kodi host
    func getMusicVideos() async -> [MediaItem] {
        let request = VideoLibraryGetMusicVideos()
        do {
            let result = try await sendRequest(request: request)
            return setMediaItem(items: result.musicvideos, media: .musicVideo)
        } catch {
            /// There are no music videos in the library
            logger("Loading music videos failed with error: \(error)")
            return [MediaItem]()
        }
    }
    
    /// Get the details of a music video
    /// - Parameter musicVideoID: The ID of the music video item
    /// - Returns: An updated Media Item
    func getMusicVideoDetails(musicVideoID: Int) async -> MediaItem {
        let request = VideoLibraryGetMusicVideoDetails(musicVideoID: musicVideoID)
        do {
            let result = try await sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return setMediaItem(items: [result.musicvideodetails], media: .musicVideo).first ?? MediaItem()
        } catch {
            logger("Loading song details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Update the details of a music video
    /// - Parameter musicVideo: The Media Item
    func setMusicVideoDetails(musicVideo: MediaItem) async {
        let message = VideoLibrarySetMusicVideoDetails(musicVideo: musicVideo)
        sendMessage(message: message)
        logger("Details set for '\(musicVideo.title)'")
    }
}

// MARK: Kodi API's

extension KodiConnector {
    
    /// The Music Video properties we ask from Kodi
    static var VideoFieldsMusicVideo = [
        "title",
        "artist",
        "album",
        "track",
        "genre",
        "file",
        "year",
        "premiered",
        "art",
        "playcount",
        "plot",
        "runtime",
        "streamdetails",
        "dateadded",
        "lastplayed"
    ]
    
    /// Retrieve all music videos (Kodi API)
    struct VideoLibraryGetMusicVideos: KodiAPI {
        /// Method
        var method = Method.videoLibraryGetMusicVideos
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.sort = sort(method: .artist, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = KodiConnector.VideoFieldsMusicVideo
            /// The sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of music videos
            let musicvideos: [KodiResponse]
        }
    }

    /// Retrieve details about a specific music video (Kodi API)
    struct VideoLibraryGetMusicVideoDetails: KodiAPI {
        /// Argument: the song we ask for
        var musicVideoID: Int
        /// Method
        var method = Method.videoLibraryGetMusicVideoDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.musicvideoid = musicVideoID
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = KodiConnector.VideoFieldsMusicVideo
            /// The ID of the music video
            var musicvideoid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            var musicvideodetails: KodiResponse
        }
    }
    
    /// Update the given music video with the given details (Kodi API)
    struct VideoLibrarySetMusicVideoDetails: KodiAPI {
        /// Arguments
        var musicVideo: MediaItem
        /// Method
        var method = Method.videoLibrarySetMusicVideoDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters
            let params = Params(musicVideo: musicVideo)
            return buildParams(params: params)
        }
        /// The request struct
        /// - Note: The properties we want to set
        struct Params: Encodable {
            internal init(musicVideo: MediaItem) {
                self.musicvideoid = musicVideo.musicVideoID
                self.userrating = musicVideo.rating
                self.playcount = musicVideo.playcount
                self.lastplayed = musicVideo.lastPlayed
            }
            /// The music video ID
            var musicvideoid: Int
            /// The rating of the song
            var userrating: Int
            /// The play count of the song
            var playcount: Int
            /// The last played date
            var lastplayed: String
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
