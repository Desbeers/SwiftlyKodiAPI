//
//  MusicVideos.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getMusicVideos

extension VideoLibrary {

    /// Get all the music videos from the Kodi host
    /// - Returns: All music videos from the Kodi host
    public static func getMusicVideos() async -> [MediaItem] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetMusicVideos()) {
            logger("Loaded \(result.musicvideos.count) music videos from the Kodi host")
            return kodi.setMediaItem(items: result.musicvideos, media: .musicVideo)
        }
        /// There are no music videos in the library
        return [MediaItem]()
    }
    
    /// Retrieve all music videos (Kodi API)
    struct GetMusicVideos: KodiAPI {
        /// Method
        var method = Methods.videoLibraryGetMusicVideos
        /// The JSON creator
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.musicVideo
            /// The sort order
            let sort = List.Sort(method: .artist, order: .ascending)
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of music videos
            let musicvideos: [KodiResponse]
        }
    }
}

// MARK:  getMusicVideoDetails

extension VideoLibrary {
    
    /// Get the details of a music video
    /// - Parameter musicVideoID: The ID of the music video item
    /// - Returns: An updated Media Item
    public static func getMusicVideoDetails(musicVideoID: Int) async -> MediaItem {
        let kodi: KodiConnector = .shared
        let request = GetMusicVideoDetails(musicVideoID: musicVideoID)
        do {
            let result = try await kodi.sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return kodi.setMediaItem(items: [result.musicvideodetails], media: .musicVideo).first ?? MediaItem()
        } catch {
            logger("Loading song details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Retrieve details about a specific music video (Kodi API)
    struct GetMusicVideoDetails: KodiAPI {
        /// The music video we ask for
        var musicVideoID: Int
        /// Method
        var method = Methods.videoLibraryGetMusicVideoDetails
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
            let properties = Video.Fields.musicVideo
            /// The ID of the music video
            var musicvideoid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the music video
            var musicvideodetails: KodiResponse
        }
    }
}

// MARK:  setMusicVideoDetails

extension VideoLibrary {
    
    /// Update the details of a music video
    /// - Parameter musicVideo: The Media Item
    public static func setMusicVideoDetails(musicVideo: MediaItem) async {
        let kodi: KodiConnector = .shared
        let message = SetMusicVideoDetails(musicVideo: musicVideo)
        kodi.sendMessage(message: message)
        logger("Details set for '\(musicVideo.title)'")
    }
    
    /// Update the given music video with the given details (Kodi API)
    struct SetMusicVideoDetails: KodiAPI {
        /// Arguments
        var musicVideo: MediaItem
        /// Method
        var method = Methods.videoLibrarySetMusicVideoDetails
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
