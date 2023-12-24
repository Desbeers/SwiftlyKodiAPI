//
//  Router.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

/// Router for Kodi client navigation
public enum Router: Hashable, Codable {

    // MARK: General

    /// Start View for Kodi client
    case start
    /// Favourites
    case favourites
    /// The search View
    case search
    /// The Kodi settings View
    case kodiSettings
    /// The App settings View
    case appSettings
    /// Kodi Host connection settings
    case hostItemSettings(host: HostItem)
    /// Now playing qeue View
    case nowPlayingQueue
    /// Fallback
    case fallback

    // MARK: Movies

    /// All movies
    case movies
    /// A specific movie
    case movie(movie: Video.Details.Movie)
    /// A movie set
    case movieSet(movieSet: Video.Details.MovieSet)
    /// All unwatched movies
    case unwatchedMovies
    /// All movie playlists
    case moviePlaylists
    /// A specific movie playlist
    case moviePlaylist(file: SwiftlyKodiAPI.List.Item.File)
    /// Random movies
    case randomMovies

    // MARK: TV shows

    /// All TV shows
    case tvshows
    /// A specific TV show
    case tvshow(tvshow: Video.Details.TVShow)
    /// All seasons of a specific TV show
    case seasons(tvshow: Video.Details.TVShow)
    /// A season of a specific TV show
    case season(season: Video.Details.Season)
    /// A specific episode
    case episode(episode: Video.Details.Episode)
    /// First unwatched episode of all TV shows
    case unwachedEpisodes

    // MARK: Music Videos

    /// A specific artist
    case musicVideoArtist(artist: Audio.Details.Artist)
    /// All music videos
    case musicVideos
    /// A specific music video
    case musicVideo(musicVideo: Video.Details.MusicVideo)
    /// A music video album
    case musicVideoAlbum(musicVideoAlbum: Video.Details.MusicVideoAlbum)

    // MARK: Music

    /// Music browser View
    case musicBrowser
    /// Music match View
    case musicMatch
    /// A specific music playlist
    case musicPlaylist(file: SwiftlyKodiAPI.List.Item.File)
    /// All compilation albums
    case compilationAlbums
    /// Recently added music
    case recentlyAddedMusic
    /// Recently played music
    case recentlyPlayedMusic
    /// Most played music
    case mostPlayedMusic
}
