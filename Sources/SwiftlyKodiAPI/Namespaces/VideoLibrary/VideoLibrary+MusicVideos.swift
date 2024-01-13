//
//  VideoLibrary+MusicVideos.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getMusicVideos

extension VideoLibrary {

    /// Retrieve all music videos (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All music videos in an ``Video/Details/MusicVideo`` array
    public static func getMusicVideos(host: HostItem) async -> [Video.Details.MusicVideo] {
        if let result = try? await JSON.sendRequest(request: GetMusicVideos(host: host)) {
            Logger.library.info("Loaded \(result.musicvideos.count) music videos from the Kodi host")
            return result.musicvideos
        }
        /// There are no music videos in the library
        Logger.library.warning("There are no music videos on the Kodi host")
        return [Video.Details.MusicVideo]()
    }

    /// Retrieve all music videos (Kodi API)
    fileprivate struct GetMusicVideos: KodiAPI {
        /// The host
        let host: HostItem
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
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - musicVideoID: The ID of the music video
    /// - Returns: A ``Video/Details/MusicVideo`` Item
    public static func getMusicVideoDetails(host: HostItem, musicVideoID: Library.ID) async -> Video.Details.MusicVideo {
        let request = GetMusicVideoDetails(host: host, musicVideoID: musicVideoID)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.musicvideodetails
        } catch {
            Logger.kodiAPI.error("Loading music video details failed with error: \(error)")
            return Video.Details.MusicVideo()
        }
    }

    /// Retrieve details about a specific music video (Kodi API)
    fileprivate struct GetMusicVideoDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.videoLibraryGetMusicVideoDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(musicVideoID: musicVideoID))
        }
        /// The music video ID
        let musicVideoID: Library.ID
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
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - musicVideo: The ``Video/Details/MusicVideo`` item
    public static func setMusicVideoDetails(host: HostItem, musicVideo: Video.Details.MusicVideo) async {
        let message = SetMusicVideoDetails(host: host, musicVideo: musicVideo)
        JSON.sendMessage(message: message)
        Logger.kodiAPI.info("Details set for '\(musicVideo.title)'")
    }

    /// Update the given music video with the given details (Kodi API)
    fileprivate struct SetMusicVideoDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.videoLibrarySetMusicVideoDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(musicVideo: musicVideo))
        }
        /// The music video
        let musicVideo: Video.Details.MusicVideo
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
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - musicVideo: The ``Video/Details/MusicVideo`` item
    public static func refreshMusicVideo(host: HostItem, musicVideo: Video.Details.MusicVideo) async {
        let message = RefreshMusicVideo(host: host, musicVideo: musicVideo)
        do {
            _ = try await JSON.sendRequest(request: message)
            Logger.kodiAPI.info("Refreshed '\(musicVideo.title)'")
        } catch {
            Logger.kodiAPI.error("Refreshing music video details failed with error: \(error)")
        }
    }

    /// Refresh the given music video in the library (Kodi API)
    fileprivate struct RefreshMusicVideo: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.videoLibraryRefreshMusicVideo
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(musicVideo: musicVideo))
        }
        /// The music video
        let musicVideo: Video.Details.MusicVideo
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
