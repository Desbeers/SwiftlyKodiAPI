//
//  KodiItem+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

public extension KodiItem {

    func getUpdate(host: HostItem) async -> (any KodiItem)? {
        switch self {
        case let movie as Video.Details.Movie:
            if let update = await VideoLibrary.getMovieDetails(host: host, movieID: self.kodiID), update != movie {
                return update
            }
        case let episode as Video.Details.Episode:
            if let update = await VideoLibrary.getEpisodeDetails(host: host, episodeID: self.kodiID), update != episode {
                return update
            }
//            if let update = kodiConnector.library.episodes.first(where: { $0.id == episode.id }), update != episode {
//                appState.focusedKodiItem = AnyKodiItem(update)
//                return update
//            }
        case let musicVideo as Video.Details.MusicVideo:
            if let update = await VideoLibrary.getMusicVideoDetails(host: host, musicVideoID: self.kodiID), update != musicVideo {
                return update
            }
//            if let update = kodiConnector.library.musicVideos.first(where: { $0.id == musicVideo.id }), update != musicVideo {
//                appState.focusedKodiItem = AnyKodiItem(update)
//                return update
//            }
        default:
            return nil
        }
        return nil
    }

    /// Mark a ``KodiItem`` as played
    /// - Parameter host: The ``HostItem`` that has the item
    func markAsPlayed(host: HostItem) async {
        var newItem = self
        newItem.playcount += 1
        newItem.lastPlayed = Utils.kodiDateFromSwiftDate(Date())
        newItem.resume.position = 0
        await setDetails(host: host, item: newItem)
    }

    /// Mark a ``KodiItem`` as new
    /// - Parameter host: The ``HostItem`` that has the item
    /// - Note: You can't set the date to nil or empty; that will be ignored, so we set it to a long time ago if needed
    func markAsNew(host: HostItem) async {
        var newItem = self
        newItem.playcount = 0
        newItem.resume.position = 0
        newItem.lastPlayed = "2000-01-01 00:00:00"
        await setDetails(host: host, item: newItem)
    }

    /// Toggle the played status of a ``KodiItem``
    /// - Parameter host: The ``HostItem`` that has the item
    /// - Note: You can't set the date to nil or empty; that will be ignored, so we set it to a long time ago if needed
    func togglePlayedState(host: HostItem) async {
        switch self.playcount {
        case 0:
            await self.markAsPlayed(host: host)
        default:
            await self.markAsNew(host: host)
        }
    }

    /// Set the resume time of a``KodiItem``
    /// - Parameter host: The ``HostItem`` that has the item
    func setResumeTime(host: HostItem, time: Double) async {
        var newItem = self
        newItem.resume.position = Double(Int(time))
        newItem.lastPlayed = Utils.kodiDateFromSwiftDate(Date())
        await setDetails(host: host, item: newItem)
    }

    /// Toggle a ``KodiItem`` as 'favorite'
    /// - Parameter host: The ``HostItem`` that has the item
    ///
    /// This will set the 'userRating' to either 10 or 0
    func toggleFavorite(host: HostItem) async {
        var newItem = self
        newItem.userRating = self.userRating < 10 ? 10 : 0
        await setDetails(host: host, item: newItem)
    }

    /// Set the user rating of a ``KodiItem``
    /// - Parameter host: The ``HostItem`` that has the item
    func setUserRating(host: HostItem, rating: Int) async {
        var newItem = self
        newItem.userRating = rating

        /// This will not trigger a notification so we have to trigger it by changing the last played value
        var lastPlayed = Utils.swiftDateFromKodiDate(newItem.lastPlayed)
        lastPlayed.addTimeInterval(60)
        newItem.lastPlayed = Utils.kodiDateFromSwiftDate(lastPlayed)

        await setDetails(host: host, item: newItem)
    }
}

extension KodiItem {

    /// Set the details of a ``KodiItem``
    /// - Parameters:
    ///   - host: The ``HostItem`` that has the item
    ///   - item: The ``KodiItem`` to set
    func setDetails(host: HostItem, item: any KodiItem) async {
        /// Convert ``KodiItem`` to the actual ``Media``
        switch item {
        case let movie as Video.Details.Movie:
            await VideoLibrary.setMovieDetails(host: host, movie: movie)
        case let movieSet as Video.Details.MovieSet:
            await movieSetDetails(host: host, set: movieSet)
        case let tvshow as Video.Details.TVShow:
            await tvshowDetails(host: host, tvshow: tvshow)
        case let episode as Video.Details.Episode:
            await VideoLibrary.setEpisodeDetails(host: host, episode: episode)
        case let musicVideo as Video.Details.MusicVideo:
            await VideoLibrary.setMusicVideoDetails(host: host, musicVideo: musicVideo)
        case let song as Audio.Details.Song:
            await AudioLibrary.setSongDetails(host: host, song: song)
        default:
            Logger.library.warning("Updating \(self.media.description) not implemented")
        }
    }

    /// Update all Movies in a MovieSet
    /// - Parameters:
    ///   - host: The ``HostItem`` that has the movies
    ///   - set: The MovieSet
    func movieSetDetails(host: HostItem, set: Video.Details.MovieSet) async {
        let setDetails = await VideoLibrary.getMovieSetDetails(host: host, setID: set.setID)
        if let movies = setDetails.movies {
            for movie in movies {
                if var update = await VideoLibrary.getMovieDetails(host: host, movieID: movie.movieID) {
                    update.playcount = set.playcount
                    update.lastPlayed = set.lastPlayed
                    update.resume = set.resume
                    await VideoLibrary.setMovieDetails(host: host, movie: update)
                }
            }
        }
    }

    /// Update all Episodes in a TV show
    /// - Parameters:
    ///   - host: The ``HostItem`` that has the episodes
    ///   - tvshow: The TV show
    func tvshowDetails(host: HostItem, tvshow: Video.Details.TVShow) async {
        var episodes = await VideoLibrary.getEpisodes(host: host, tvshowID: tvshow.tvshowID)
        for index in episodes.indices {
            episodes[index].playcount = tvshow.playcount
            episodes[index].lastPlayed = tvshow.lastPlayed
            episodes[index].resume.position = tvshow.resume.position
            await VideoLibrary.setEpisodeDetails(host: host, episode: episodes[index])
        }
        /// Update the TV show itself
        await VideoLibrary.setTVShowDetails(host: host, tvshow: tvshow)
    }
}
