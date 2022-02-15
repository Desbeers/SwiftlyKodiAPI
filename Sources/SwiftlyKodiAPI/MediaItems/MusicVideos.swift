//
//  KodiMovies.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 01/02/2022.
//

import Foundation

extension KodiClient {
    
    public func getMusicVideos() async -> [MusicVideoItem] {
        let request = VideoLibraryGetMusicVideos()
        do {
            let result = try await sendRequest(request: request)
            return result.musicvideos
        } catch {
            /// There are no songs in the library
            print("Loading movies failed with error: \(error)")
            return [MusicVideoItem]()
        }
    }
    
    /// Retrieve all songs (Kodi API)
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
            let properties = [
                "title",
                "artist",
                "album",
                "genre",
                "file",
                "year",
                "premiered",
                "art",
                "playcount",
                "plot",
                "runtime"
            ]
            /// The sort order
            var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of music videos
            let musicvideos: [MusicVideoItem]
        }
    }
}

/// The struct for a movie item
public struct MusicVideoItem: KodiMediaProtocol, Identifiable, Hashable {
    /// Make it indentifiable
    public var id = UUID()
    /// # Metadata we get from Kodi
//    /// Title of the music video
//    public var title: String = ""
    /// Artist of the music video
    public var artist: [String] = []
    /// Album of the music video
    public var album: String = ""
    /// Description of the music video (is actually the plot)
    public var description: String = ""
    /// An array with the music video genres
    public var genre: [String] = [""]
    /// Location of the music video
    public var file: String = ""
    /// An array with cast of the movie
    public var cast: [ActorItem] = []
    /// Art of the music video
    public var art: [String: String] = [:]
    /// Release year of the music video
    public var year: Int = 0
    /// Premiered date of the music video
    public var premiered: String = ""
    /// Playcount of the music video
    public var playCount: Int = 0
    /// Runtime of the music video
    public var runtime: Int = 0
    /// # Coding keys
    /// All the coding keys for a music video item
    enum CodingKeys: String, CodingKey {
        /// The keys
        case artist, album, file, art, year, premiered, genre, runtime
        /// lowerCamelCase
        case playCount = "playcount"
        /// Use title as subtitle
        case subtitle = "title"
        /// Use 'plot' as description
        case description = "plot"
    }
    /// # Calculated stuff
    /// Subtitle of the music video; we use the genres here
    public var title: String {
        return artist.joined(separator: "・")
    }
    /// This is the title of the music video
    public var subtitle: String?
    
    /// The sort order of the music video
    public var sortOrder: String {
        return artist.first!
    }
}
