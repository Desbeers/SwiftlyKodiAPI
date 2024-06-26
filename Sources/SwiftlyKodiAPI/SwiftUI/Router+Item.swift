//
//  Router+Item.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI

public extension Router {

    /// Structure for a ``Router`` Item
    struct Item {
        /// Title of the item
        public var title: String = "Title"
        /// Description of the item
        public var description: String = "Description"
        /// Loading message of the item
        public var loading: String = "Loading"
        /// Message when the item is empty
        public var empty: String = "Empty"
        /// The SF symbol for the item
        public var icon: String = "square.dashed"
        /// The color of the item
        public var color: Color = Color("AccentColor")
        /// The optional KodiItem
        public var kodiItem: (any KodiItem)?
    }
}

public extension Router {

    /// Details f the router item
    var item: Item {
        switch self {

            // MARK: General

        case .start:
            let appName = Bundle.main.clientName
            return Item(
                title: "\(appName)",
                description: "Welcome to \(appName)",
                loading: "Connecting",
                empty: "Not connected",
                icon: "house",
                color: Color("AccentColor")
            )
        case .home:
            let appName = Bundle.main.clientName
            return Item(
                title: "\(appName)",
                description: "Welcome to \(appName)",
                loading: "Connecting",
                empty: "Not connected",
                icon: "sparkles.tv",
                color: Color("AccentColor")
            )
        case .favourites:
            return Item(
                title: "Favourites",
                description: "Your favourite items",
                loading: "Loading your favourite items",
                empty: "You have no favourite items",
                icon: "heart.fill",
                color: Color("Favorites", bundle: Bundle.module)
            )
        case .search:
            return Item(
                title: "Search",
                description: "Search your library",
                loading: "Searching your library",
                empty: "No items found",
                icon: "magnifyingglass",
                color: Color("AccentColor")
            )
        case .kodiSettings:
            return Item(
                title: "Kodi settings",
                description: "The settings on your host",
                loading: "Loading your settings",
                empty: "There are no settings",
                icon: "gear",
                color: Color("AccentColor")
            )
        case .appSettings:
            let appName = Bundle.main.clientName
            return Item(
                title: "Settings",
                description: "The settings for \(appName)",
                loading: "Loading your settings",
                empty: "There are no settings",
                icon: "gear",
                color: Color("AccentColor")
            )
        case .hostItemSettings(let host):
            return Item(
                title: "Host settings",
                description: "Settings for `\(host.name)`",
                loading: "Loading your settings",
                empty: "There are no settings",
                icon: "gear",
                color: Color("AccentColor")
            )
        case .nowPlayingQueue:
            return Item(
                title: "Now Playing",
                description: "The current queue",
                loading: "Loading the queue",
                empty: "There is nothing in your queue at the moment",
                icon: "list.triangle",
                color: .purple
            )
        case .rating(let item):
            return Item(
                title: "Rate \(item.item.title)",
                description: "Set the rating for \(item.item.title)",
                loading: "Loading \(item.item.title)",
                empty: "\(item.item.title) was not found",
                icon: "star",
                color: .purple
            )

            // MARK: Movies

        case .movies:
            return Item(
                title: "All Movies",
                description: "All the Movies in your Library",
                loading: "Loading your Movies",
                empty: "There are no Movies in your Library",
                icon: "film",
                color: .teal
            )
        case .movie(let movie):
            return Item(
                title: "\(movie.title)",
                description: "\(movie.subtitle)",
                loading: "Loading `\(movie.title)`",
                empty: "`\(movie.title)` was not found",
                icon: "film",
                color: .teal,
                kodiItem: movie
            )
        case .movieSet(let movieSet):
            return Item(
                title: "\(movieSet.title)",
                description: "\(movieSet.subtitle)",
                loading: "Loading `\(movieSet.title)`",
                empty: "`\(movieSet.title)` was not found",
                icon: "circle.grid.cross.fill",
                color: .teal,
                kodiItem: movieSet
            )
        case .unwatchedMovies:
            return Item(
                title: "Unwatched Movies",
                description: "Movies you have not seen yet",
                loading: "Loading your Unwatched Movies",
                empty: "You have no Unwatched Movies in your library",
                icon: "eye",
                color: .teal
            )
        case .moviePlaylists:
            return Item(
                title: "Movie Playlists",
                description: "All your Movie Playlists",
                loading: "Loading your Movie Playlists",
                empty: "You have no Movie Playlists in your library",
                icon: "list.triangle",
                color: .purple
            )
        case .moviePlaylist(let file):
            return Item(
                title: "\(file.label)",
                description: "Movie playlist",
                loading: "Loading the playlist",
                empty: "The playlist is empty",
                icon: "list.triangle",
                color: .purple
            )
        case .randomMovies:
            return Item(
                title: "Random Movies",
                description: "Random movies from your Library",
                loading: "Loading your Movies",
                empty: "There are no Movies in your Library",
                icon: "film",
                color: .teal
            )
        case .countries:
            return Item(
                title: "All countries",
                description: "All your movies by country",
                loading: "Loading your Movies",
                empty: "There are no Movies in your Library",
                icon: "flag",
                color: .teal
            )
        case .country(let country):
            return Item(
                title: "\(country)",
                description: "All your movies from \(country)",
                loading: "Loading your Movies",
                empty: "There are no Movies from \(country) in your Library",
                icon: "flag",
                color: .teal
            )

            // MARK: TV shows

        case .tvshows:
            return Item(
                title: "All TV shows",
                description: "All the TV shows in your Library",
                loading: "Loading your TV shows",
                empty: "There are no TV shows in your Library",
                icon: "tv",
                color: .indigo
            )
        case .tvshow(let tvshow):
            return Item(
                title: "\(tvshow.title)",
                description: "\(tvshow.subtitle)",
                loading: "Loading `\(tvshow.title)`",
                empty: "`\(tvshow.title)` was not found",
                icon: "tv",
                color: .indigo,
                kodiItem: tvshow
            )
        case .seasons(let tvshow):
            return Item(
                title: "All Seasons",
                description: "All the Seasons from `\(tvshow.title)`",
                loading: "Loading your Seasons",
                empty: "There are no Seasons for `\(tvshow.title)` in your Library",
                icon: "tv",
                color: .indigo,
                kodiItem: tvshow
            )
        case .season(let season):
            var description = "All the Episodes from Season \(season.season)"
            if season.season == 0 {
                description = "All the Specials"
            }
            return Item(
                title: "\(season.title)",
                description: description,
                loading: "Loading your Episodes",
                empty: "There are no Episodes in Season \(season.season)",
                icon: "tv",
                color: .indigo,
                kodiItem: season
            )
        case .episode(let episode):
            return Item(
                title: "\(episode.title)",
                description: "\(episode.subtitle)",
                loading: "Loading `\(episode.title)`",
                empty: "`\(episode.title)` was not found",
                icon: "tv",
                color: .indigo,
                kodiItem: episode
            )
        case .unwachedEpisodes:
            return Item(
                title: "Up Next",
                description: "Watch the next Episode of a TV show",
                loading: "Loading your Episodes",
                empty: "There are no new Episodes in your Library",
                icon: "eye",
                color: .indigo
            )

            // MARK: Music Videos

        case .musicVideoArtist(let artist):
            return Item(
                title: "\(artist.title)",
                description: "\(artist.subtitle)",
                loading: "Loading `\(artist.title)`",
                empty: "`\(artist.title)` was not found",
                icon: "music.note.tv",
                color: .cyan,
                kodiItem: artist
            )
        case .musicVideos:
            return Item(
                title: "All Music Videos",
                description: "All the Music Videos in your Library",
                loading: "Loading your Music Videos",
                empty: "There are no Music Videos in your Library",
                icon: "music.note.tv",
                color: .indigo
            )
        case .musicVideo(let musicVideo):
            return Item(
                title: "\(musicVideo.title)",
                description: "\(musicVideo.subtitle)",
                loading: "Loading `\(musicVideo.title)`",
                empty: "`\(musicVideo.title)` was not found",
                icon: "music.note.tv",
                color: .cyan,
                kodiItem: musicVideo
            )
        case .musicVideoAlbum(let musicVideoAlbum):
            return Item(
                title: "\(musicVideoAlbum.album)",
                description: "All Music Videos from `\(musicVideoAlbum.album)`",
                loading: "Loading `\(musicVideoAlbum.album)`",
                empty: "`\(musicVideoAlbum.album)` was not found",
                icon: "music.note.tv",
                color: .cyan,
                kodiItem: musicVideoAlbum
            )

            // MARK: Music

        case .musicBrowser:
            return Item(
                title: "All Music",
                description: "All the Music in your Library",
                loading: "Loading your Music",
                empty: "There is no Music in your Library",
                icon: "music.quarternote.3",
                color: .indigo
            )
        case .musicMatch:
            return Item(
                title: "Music Match",
                description: "Match playcounts and ratings between Kodi and Music",
                loading: "Matching your Music",
                empty: "Music Match is not available",
                icon: "arrow.triangle.2.circlepath",
                color: .brown
            )
        case .musicPlaylist(let file):
            return Item(
                title: "\(file.title)",
                description: "Music playlist",
                loading: "Loading the playlist",
                empty: "The playlist is empty",
                icon: "list.triangle",
                color: .purple
            )
        case .compilationAlbums:
            return Item(
                title: "Compilations",
                description: "All compilation albums",
                loading: "Loading your compilation albums",
                empty: "You have no compilation albums in your Library",
                icon: "person.2",
                color: .indigo
            )
        case .recentlyAddedMusic:
            return Item(
                title: "Recently Added",
                description: "Your recently added music",
                loading: "Loading your recently added music",
                empty: "You have no recently added music in your Library",
                icon: "star",
                color: .indigo
            )
        case .recentlyPlayedMusic:
            return Item(
                title: "Recently Played",
                description: "Your recently played music",
                loading: "Loading your recently played music",
                empty: "You have no recently played music in your Library",
                icon: "gobackward",
                color: .indigo
            )
        case .mostPlayedMusic:
            return Item(
                title: "Most Played",
                description: "Your most played music",
                loading: "Loading your most played music",
                empty: "You have no most played music in your Library",
                icon: "infinity",
                color: .indigo
            )

            // MARK: Fallback

        default:
            return Item()
        }
    }
}
