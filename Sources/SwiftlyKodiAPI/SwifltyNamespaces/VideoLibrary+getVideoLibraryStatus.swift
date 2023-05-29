//
//  VideoLibrary+getVideoLibraryStatus.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension VideoLibrary {

    // MARK: VideoLibrary.getVideoLibraryStatus

    /// Get the status of the Video Library  (SwiftlyKodi API)
    /// - Returns: Current status of all video items
    public static func getVideoLibraryStatus() async -> Library.Status {
        async let movies = Files.getDirectory(directory: "library://video/movies/titles.xml", media: .video)
        async let tvshows = Files.getDirectory(directory: "library://video/tvshows/titles.xml", media: .video)
        async let musicVideos = Files.getDirectory(directory: "library://video/musicvideos/titles.xml", media: .video)
        return await Library.Status(movies: movies, tvshows: tvshows, musicVideos: musicVideos)
    }
}
