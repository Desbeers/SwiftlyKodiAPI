//Library.swift
//  SwiftlyKodiAPI
//  
//  Created by Nick Berendsen on 18/02/2022.
//

import SwiftUI

extension KodiConnector {
    
    /// Get a Binding from a ``KodiItem`` to the Kodi library
    ///  n SwiftUI if yo fiter the library in a `ForEach` you can't use the 'normal' Binding $ anymore
    /// - Parameter item: A Kodi item
    /// - Returns: A Binding to the Kodi library
    func getLibraryBinding(item: KodiItem) -> Binding<KodiItem> {
        return  Binding<KodiItem>(
            get: { self.library.first(where: { $0.id == item.id}) ?? item },
            set: {newValue in
                if let index = self.library.firstIndex(where: { $0.id == item.id}) {
                    /// Update the library
                    Task { @MainActor in
                        self.library[index] = newValue
                    }
                }
            })
    }
    
    /// Mark a Video item as watched
    /// - Parameter video: The Kodi video item that is watched
    @MainActor public func markVideoAsWatched(_ video: KodiItem) {
        print("Mark \(video.title) as watched")
        if let index = library.firstIndex(where: { $0.id == video.id }) {
            library[index].playcount = video.playcount + 1
            setPlaycount(library[index])
        }
    }
    
//    /// Toggle the watched status of a Video item
//    /// - Parameter item: The Kodi video item to toggle
//    @MainActor func toggleWatchedState(_ item: KodiItem) -> KodiItem {
////        if let index = library.firstIndex(where: { $0.id == item.id }) {
////            //library[index].playcount = item.playcount == 0 ? 1 : 0
//            setPlaycount(item)
////            return library[index]
////        }
////        return item
//    }
    
    /// Set the play count of a Kodi item
    /// - Parameter item: The Kodi item
    func setPlaycount(_ item: KodiItem) {
        let message = LibrarySetPlaycount(item: item)
        sendMessage(message: message)
    }
    
    /// Update the given song with the given details (Kodi API)
    struct LibrarySetPlaycount: KodiAPI {
        /// Arguments
        var item: KodiItem
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


