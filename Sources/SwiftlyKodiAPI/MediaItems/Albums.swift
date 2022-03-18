//
//  Albums.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Get all albums from the Kodi host
    /// - Returns: All albums from the Kodi host
    func getAlbums() async -> [MediaItem] {
            let request = AudioLibraryGetAlbums()
            do {
                let result = try await sendRequest(request: request)
                return setMediaItem(items: result.albums, media: .album)
            } catch {
                /// There are no artists in the library
                logger("Loading albums failed with error: \(error)")
                return [MediaItem]()
            }
    }
}

// MARK: Album item extension

extension MediaItem {
    
    /// Add additional fields to the album item
    /// - Note: This is a *slow* function...
    mutating func addAlbumFields() {
        if self.fanart == self.poster {
            if let artist = KodiConnector.shared.media.first(where: { $0.media == .artist && $0.artistID == self.artistIDs.first }) {
                self.fanart = artist.fanart
            }
        }
    }
}

// MARK: Kodi API's

extension KodiConnector {
    
    /// Retrieve all albums (Kodi API)
    struct AudioLibraryGetAlbums: KodiAPI {
        /// Method
        let method = Method.audioLibraryGetAlbums
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.sort = sort(method: .artist, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties
            let properties = [
                "artistid",
                "artist",
                "sortartist",
                "description",
                "title",
                "year",
                "playcount",
                "totaldiscs",
                "genre",
                "art",
                "compilation",
                "dateadded",
                "lastplayed",
                "albumduration"
            ]
            /// Sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of albums
            let albums: [KodiResponse]
        }
    }
}
