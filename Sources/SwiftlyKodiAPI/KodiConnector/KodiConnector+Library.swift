//
//  KodiConnector+Library.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyStructCache
import OSLog

extension KodiConnector {

    func getLibrary() async -> Library.Items {

        /// # Helpers

        @Sendable func getAudio() async -> Library.Items {
            async let albums = AudioLibrary.getAlbums(host: host)
            async let songs = AudioLibrary.getSongs(host: host)
            async let audioGenres = AudioLibrary.getGenres(host: host)
            async let audioLibraryProperties = AudioLibrary.getProperties(host: host)
            return await Library.Items(
                albums: albums,
                songs: songs,
                audioGenres: audioGenres,
                audioLibraryProperties: audioLibraryProperties
            )
        }

        @Sendable func getVideo() async -> Library.Items {
            async let movies = VideoLibrary.getMovies(host: host)
            async let movieSets = VideoLibrary.getMovieSets(host: host)
            async let tvshows = VideoLibrary.getTVShows(host: host)
            async let episodes = VideoLibrary.getEpisodes(host: host)
            async let videoGenres = VideoLibrary.getAllVideoGenres(host: host)
            return await Library.Items(
                movies: movies,
                movieSets: movieSets,
                tvshows: tvshows,
                episodes: episodes,
                videoGenres: videoGenres
            )
        }

        async let artist = AudioLibrary.getArtists(host: host)
        async let musicVideos = VideoLibrary.getMusicVideos(host: host)
        switch host.media {
        case .audio:
            async let audio = getAudio()
            return await Library.Items(
                artists: artist,
                albums: audio.albums,
                songs: audio.songs,
                audioGenres: audio.audioGenres,
                audioLibraryProperties: audio.audioLibraryProperties,
                musicVideos: musicVideos
            )
        case .video:
            async let video = getVideo()
            return await Library.Items(
                artists: artist,
                movies: video.movies,
                movieSets: video.movieSets,
                tvshows: video.tvshows,
                episodes: video.episodes,
                musicVideos: musicVideos,
                videoGenres: video.videoGenres
            )
        case .all:
            async let audio = getAudio()
            async let video = getVideo()
            return await Library.Items(
                artists: artist,
                albums: audio.albums,
                songs: audio.songs,
                audioGenres: audio.audioGenres,
                movies: video.movies,
                movieSets: video.movieSets,
                tvshows: video.tvshows,
                episodes: video.episodes,
                musicVideos: musicVideos,
                videoGenres: video.videoGenres
            )
        default:
            return Library.Items()
        }
    }

    /// Store the library in the cache
    /// - Parameter media: The whole media libray
    /// - Note: This function will debounce for 2 seconds to avoid overload when we have a large library update
    func setLibraryCache() async {
        await task.setLibraryCache.submit {
            do {
                try Cache.set(
                    key: "MyLibrary",
                    object: self.library,
                    folder: self.host.ip
                )
                try await Cache.set(
                    key: "VideoLibraryStatus",
                    object: VideoLibrary.getVideoLibraryStatus(host: self.host),
                    folder: self.host.ip
                )
            } catch {
                Logger.library.error("Saving library failed with error: \(error)")
            }
        }
    }
}
