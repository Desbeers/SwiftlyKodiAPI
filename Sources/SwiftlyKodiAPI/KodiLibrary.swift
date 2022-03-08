//Library.swift
//  SwiftlyKodiAPI
//  
//  Created by Nick Berendsen on 18/02/2022.
//

import SwiftUI

extension KodiConnector {
    
    /// Get a Binding from a ``MediaItem`` to the Kodi library
    ///
    /// In SwiftUI, if you filter the media items in a `ForEach` you can't use the 'normal' Binding $ anymore
    /// - Parameter item: A Media item
    /// - Returns: A Binding to the Kodi library
    func getLibraryBinding(item: MediaItem) -> Binding<MediaItem> {
        return  Binding<MediaItem>(
            get: { self.media.first(where: { $0.id == item.id}) ?? item },
            set: { newValue in
                /// Nothing to do here...
            }
        )
    }

    /// Set the play count of a Kodi item
    /// - Parameter item: The Kodi item
    func setPlaycount(_ item: MediaItem) {
        /// Update the Kodi database
        let message = LibrarySetPlaycount(item: item)
        sendMessage(message: message)
        logger("Database update for \(item.title), playcount = \(item.playcount)")
        /// Update our UI
        if let index = self.media.firstIndex(where: { $0.id == item.id}) {
            /// Update the library
            Task { @MainActor in
                self.media[index] = item
                logger("SwiftUI update for \(item.title), playcount = \(item.playcount)")
            }
        }
    }
    
    /// Update the given song with the given details (Kodi API)
    struct LibrarySetPlaycount: KodiAPI {
        /// Arguments
        var item: MediaItem
        /// Method
        var method: Method {
            return item.media.setDetailsMethod
        }
        /// The JSON creator
        var parameters: Data {
            /// The parameters
            var params = Params()
            /// Add the correct media ID
            switch item.media {
            case .movie:
                params.movieid = item.movieID
            case .episode:
                params.episodeid = item.episodeID
            case .musicvideo:
                params.musicvideoid = item.musicvideoID
            default:
                break
            }
            params.playcount = item.playcount
            return buildParams(params: params)
        }
        /// The request struct
        /// - Note: The properties we want to set
        struct Params: Encodable {
            /// The item ID's
            /// - Note: Optionals or else Kodi will dump an error
            var movieid: Int?
            var episodeid: Int?
            var musicvideoid: Int?
            /// The playcount of the item
            var playcount: Int = 0
        }
        /// The response struct
        struct Response: Decodable { }
    }
}


