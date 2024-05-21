//
//  Library+VideoFiles.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Library {

    /// All video files from the video of the library (SwiftlyKodi Type)
    ///
    /// - Note: Used to check for updates
    struct VideoFiles: Codable, Sendable {
        /// The movies in the library
        public var movies: [List.Item.File] = []
        /// The tvshows in the library
        public var tvshows: [List.Item.File] = []
        /// The music videos in the library
        public var musicVideos: [List.Item.File] = []
    }
}
