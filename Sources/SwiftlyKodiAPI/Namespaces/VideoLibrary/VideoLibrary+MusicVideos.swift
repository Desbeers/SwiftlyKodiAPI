//
//  VideoLibrary+MusicVideos.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getMusicVideos

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
        /// The method
        let method = Method.videoLibraryGetMusicVideos
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
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

// MARK: getMusicVideoDetails

extension VideoLibrary {

    /// Retrieve details about a specific music video (Kodi API)
    /// - Parameter musicVideoID: The ID of the music video
    /// - Returns: A ``Video/Details/MusicVideo`` Item
    public static func getMusicVideoDetails(musicVideoID: Library.ID) async -> Video.Details.MusicVideo {
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
        /// The music video ID
        let musicVideoID: Library.ID
        /// The method
        let method = Method.videoLibraryGetMusicVideoDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(musicVideoID: musicVideoID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.musicVideo
            /// The ID of the music video
            let musicVideoID: Library.ID
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case properties
                case musicVideoID = "musicvideoid"
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the music video
            let musicvideodetails: Video.Details.MusicVideo
        }
    }
}

// MARK: setMusicVideoDetails

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
        /// The music video
        let musicVideo: Video.Details.MusicVideo
        /// The method
        let method = Method.videoLibrarySetMusicVideoDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(musicVideo: musicVideo))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// Init the params
            init(musicVideo: Video.Details.MusicVideo) {
                self.musicVideoID = musicVideo.musicVideoID
                self.userRating = musicVideo.userRating
                self.playcount = musicVideo.playcount
                self.lastPlayed = musicVideo.lastPlayed
                self.resume = musicVideo.resume
            }
            /// The music video ID
            let musicVideoID: Library.ID
            /// The rating of the song
            let userRating: Int
            /// The play count of the song
            let playcount: Int
            /// The last played date
            let lastPlayed: String
            /// The resume time
            let resume: Video.Resume
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case musicVideoID = "musicvideoid"
                case userRating = "userrating"
                case playcount
                case lastPlayed = "lastplayed"
                case resume
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}

// MARK: refreshMusicVideo

extension VideoLibrary {

    /// Refresh the given music video in the library (Kodi API)
    /// - Parameter musicVideo: The ``Video/Details/MusicVideo`` item
    public static func refreshMusicVideo(musicVideo: Video.Details.MusicVideo) async {
        let kodi: KodiConnector = .shared
        let message = RefreshMusicVideo(musicVideo: musicVideo)
        do {
            _ = try await kodi.sendRequest(request: message)
            logger("Refreshed '\(musicVideo.title)'")
        } catch {
            logger("Refreshing music video details failed with error: \(error)")
        }
    }

    /// Refresh the given music video in the library (Kodi API)
    fileprivate struct RefreshMusicVideo: KodiAPI {
        /// The music video
        let musicVideo: Video.Details.MusicVideo
        /// The method
        let method = Method.videoLibraryRefreshMusicVideo
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(musicVideo: musicVideo))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// Init the params
            init(musicVideo: Video.Details.MusicVideo) {
                self.musicVideoID = musicVideo.musicVideoID
            }
            /// The music video ID
            let musicVideoID: Library.ID
            /// Ignore existing NFO
            let ignoreNFO: Bool = false
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case musicVideoID = "musicvideoid"
                case ignoreNFO = "ignorenfo"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
