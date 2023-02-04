//
//  Library+Status.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Library {

    /// The status of the library (SwiftlyKodi Type)
    struct Status: Codable {
        /// The movies in the library
        public var movies: [List.Item.File] = []
        /// The tvshows in the library
        public var tvshows: [List.Item.File] = []
        /// The music videos in the library
        public var musicVideos: [List.Item.File] = []
    }
}
