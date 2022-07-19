//
//  VideoLibrary+MusicVideos.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getMusicVideos

extension VideoLibrary {

    /// Retrieve all music videos (Kodi API)
    /// - Returns: All music videos in an ``Video/Details/MusicVideo`` array
    public static func getMusicVideos() async -> [Video.Details.MusicVideo] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetMusicVideos()) {
            logger("Loaded \(result.musicvideos.count) music videos from the Kodi host")
            return result.musicvideos
        }
        /// There are no music videos in the library
        return [Video.Details.MusicVideo]()
    }
    
    /// Retrieve all music videos (Kodi API)
    fileprivate struct GetMusicVideos: KodiAPI {
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
            let musicvideos: [Video.Details.MusicVideo]
        }
    }
}

// MARK:  getMusicVideoDetails

extension VideoLibrary {
    
    /// Retrieve details about a specific music video (Kodi API)
    /// - Parameter musicVideoID: The ID of the music video
    /// - Returns: A ``Video/Details/MusicVideo`` Item
    public static func getMusicVideoDetails(musicVideoID: Int) async -> Video.Details.MusicVideo {
        let kodi: KodiConnector = .shared
        let request = GetMusicVideoDetails(musicVideoID: musicVideoID)
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.musicvideodetails
        } catch {
            logger("Loading music video details failed with error: \(error)")
            return Video.Details.MusicVideo()
        }
    }
    
    /// Retrieve details about a specific music video (Kodi API)
    fileprivate struct GetMusicVideoDetails: KodiAPI {
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
            var musicvideodetails: Video.Details.MusicVideo
        }
    }
}

// MARK:  setMusicVideoDetails

extension VideoLibrary {
    
    /// Update the given music video with the given details (Kodi API)
    /// - Parameter musicVideo: The ``Video/Details/MusicVideo`` item
    public static func setMusicVideoDetails(musicVideo: Video.Details.MusicVideo) async {
        let kodi: KodiConnector = .shared
        let message = SetMusicVideoDetails(musicVideo: musicVideo)
        kodi.sendMessage(message: message)
        logger("Details set for '\(musicVideo.title)'")
    }
    
    /// Update the given music video with the given details (Kodi API)
    fileprivate struct SetMusicVideoDetails: KodiAPI {
        /// Arguments
        var musicVideo: Video.Details.MusicVideo
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
            internal init(musicVideo: Video.Details.MusicVideo) {
                self.musicvideoid = musicVideo.musicVideoID
                self.userrating = musicVideo.userRating
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
