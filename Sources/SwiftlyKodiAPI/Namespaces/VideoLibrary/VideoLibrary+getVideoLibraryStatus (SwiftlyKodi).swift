//
//  VideoLibrary+getVideoLibraryStatus.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

// MARK: getVideoLibraryStatus

extension VideoLibrary {

    /// Get the status of the Video Library (SwiftlyKodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: Current status of all video items
    public static func getVideoLibraryStatus(host: HostItem) async -> Library.VideoFiles {
        async let movies = Files.getDirectory(
            host: host,
            directory: "library://video/movies/titles.xml",
            media: .video
        )
        async let tvshows = Files.getDirectory(
            host: host,
            directory: "library://video/tvshows/titles.xml",
            media: .video
        )
        async let musicVideos = Files.getDirectory(
            host: host,
            directory: "library://video/musicvideos/titles.xml",
            media: .video
        )
        return await Library.VideoFiles(movies: movies, tvshows: tvshows, musicVideos: musicVideos)
    }
}
