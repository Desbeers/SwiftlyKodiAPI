//
//  KodiConnector+Update.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyStructCache
import OSLog

extension KodiConnector {

    /// Get the video library updates
    @MainActor func getVideoLibraryUpdates() async {

        if let videoLibraryStatus = try? Cache.get(key: "VideoLibraryStatus", as: Library.VideoFiles.self, folder: host.ip) {
            let currentStatus = await VideoLibrary.getVideoLibraryStatus()
            if currentStatus.movies != videoLibraryStatus.movies {
                Logger.library.warning("Movies are outdated")
                await updateItems(
                    old: videoLibraryStatus.movies,
                    new: currentStatus.movies,
                    media: .movie
                )
            }
            if currentStatus.tvshows != videoLibraryStatus.tvshows {
                Logger.library.warning("TV shows are outdated")
                await updateItems(
                    old: videoLibraryStatus.tvshows,
                    new: currentStatus.tvshows,
                    media: .tvshow
                )
            }
            if currentStatus.musicVideos != videoLibraryStatus.musicVideos {
                Logger.library.warning("Music Videos are outdated")
                await updateItems(
                    old: videoLibraryStatus.musicVideos,
                    new: currentStatus.musicVideos,
                    media: .musicVideo
                )
            }
        } else {
            /// Reload the library, status is unknown
            setStatus(.updatingLibrary)
            async let updates = getLibrary()
            library = await updates
        }

        /// Helper function to update video media
        /// - Parameters:
        ///   - old: List of old values
        ///   - new: List of new values
        ///   - media: The kind of media
        func updateItems(old: [List.Item.File], new: [List.Item.File], media: Library.Media) async {
            setStatus(.updatingLibrary)
            /// Get the Library ID's that we have to update
            var updates = Set(new.arrayDiff(from: old).compactMap(\.id))
            let oldItems = old.compactMap(\.id).sorted()
            let newItems = new.compactMap(\.id).sorted()
            /// Find the differences
            let difference = newItems.difference(from: oldItems)
            /// If the media is `TV show`, deal with the `episodes` first
            switch media {
            case .tvshow:
                for tvshowID in updates {
                    if let index = library.tvshows.firstIndex(where: { $0.tvshowID == tvshowID }) {
                        library.tvshows.remove(at: index)
                        library.episodes.removeAll(where: { $0.tvshowID == tvshowID })
                    }
                    let episodes = await VideoLibrary.getEpisodes(tvshowID: tvshowID)
                    library.episodes += episodes
                }
            default:
                break
            }
            /// Remove or insert items
            for change in difference {
                switch change {
                case let .remove(_, oldElement, _):
                    updates.remove(oldElement)
                    deleteKodiItem(itemID: oldElement, media: media)
                case let .insert(_, newElement, _):
                    updates.remove(newElement)
                    updateKodiItem(itemID: newElement, media: media)
                }
            }
            /// Update the remaining items
            for update in updates {
                updateKodiItem(itemID: update, media: media)
            }
        }
    }


    /// Get the audio library updates
    @MainActor public func getAudioLibraryUpdates() async {
        let dates = await AudioLibrary.getProperties()
        /// Check if we are outdated
        if dates != library.audioLibraryProperties {
            setStatus(.updatingLibrary)
            if library.audioLibraryProperties.songsModified != dates.songsModified {
                Logger.library.warning("Songs are modified")
                /// Update the songs
                let songs = await AudioLibrary.getSongs(modificationDate: library.audioLibraryProperties.songsModified)
                /// Don't bother if there are too many songs to update; just mark the library as 'outdated'
                if songs.count < 100 {
                    for song in songs {
                        if let index = library.songs.firstIndex(where: { $0.songID == song.songID }) {
                            library.songs[index] = song
                            Logger.library.notice("Updated \(song.title)")
                        }
                    }
                    /// Store the date
                    library.audioLibraryProperties.songsModified = dates.songsModified
                } else {
                    Logger.library.error("Too many songs are modified")
                }
            }
            if library.audioLibraryProperties.artistsModified != dates.artistsModified {
                Logger.library.warning("Artists are modified")
            }

            /// Store the library in the cache
            await setLibraryCache()
        }
        /// Set the status
        setStatus(dates == library.audioLibraryProperties ? .loadedLibrary : .outdatedLibrary)
    }

    /// Update a ``KodiItem`` in the library
    ///
    /// If it is not found in the library, it will be added
    ///
    /// - Parameters:
    ///   - itemID: The ``Library/id`` of the item
    ///   - media: The kind of ``Media``
    func updateKodiItem(itemID: Library.ID, media: Library.Media) {
        Task {
            /// The title of the item that needs an update
            var title = ""
            switch media {
            case .artist:
                let dates = await AudioLibrary.getProperties()
                library.audioLibraryProperties.artistsModified = dates.artistsModified
                if let index = library.artists.firstIndex(where: { $0.artistID == itemID }) {
                    library.artists[index] = await AudioLibrary.getArtistDetails(artistID: itemID)
                }
            case .song:
                let dates = await AudioLibrary.getProperties()
                let update = await AudioLibrary.getSongDetails(songID: itemID)
                title = update.title
                library.audioLibraryProperties.songsModified = dates.songsModified
                if let index = library.songs.firstIndex(where: { $0.songID == itemID }) {
                    library.songs[index] = update
                }
            case .movie:
                let update = await VideoLibrary.getMovieDetails(movieID: itemID)
                if let index = library.movies.firstIndex(where: { $0.movieID == itemID }) {
                    library.movies[index] = update
                } else {
                    library.movies.append(update)
                }
                /// Update movie sets if this movie is a part of it
                if update.setID != 0 {
                    updateKodiItem(itemID: update.setID, media: .movieSet)
                }
            case .movieSet:
                let update = await VideoLibrary.getMovieSetDetails(setID: itemID)
                if let index = library.movieSets.firstIndex(where: { $0.setID == itemID }) {
                    library.movieSets[index].playcount = update.playcount
                }
            case .tvshow:
                let update = await VideoLibrary.getTVShowDetails(tvshowID: itemID)
                if let index = library.tvshows.firstIndex(where: { $0.tvshowID == itemID }) {
                    library.tvshows[index] = update
                } else {
                    library.tvshows.append(update)
                }
            case .episode:
                let update = await VideoLibrary.getEpisodeDetails(episodeID: itemID)
                if let index = library.episodes.firstIndex(where: { $0.episodeID == itemID }) {
                    library.episodes[index] = update
                } else {
                    library.episodes.append(update)
                }
                /// Always check the TV show when an episode is updated
                updateKodiItem(itemID: update.tvshowID, media: .tvshow)
            case .musicVideo:
                let update = await VideoLibrary.getMusicVideoDetails(musicVideoID: itemID)
                if let index = library.musicVideos.firstIndex(where: { $0.musicVideoID == itemID }) {
                    library.musicVideos[index] = update
                } else {
                    library.musicVideos.append(update)
                }
            default:
                Logger.library.warning("Library update for \(media.description) not implemented.")
            }
            /// Log the update
            Logger.library.info("Updated \(media.description) '\(title )' in the library")
            /// Update the favorites
            favourites = await getFavourites()
            /// Store the library in the cache
            await setLibraryCache()
        }
    }

    /// Delete a ``KodiItem`` from the library
    /// - Parameters:
    ///   - itemID: The ``Library/id`` of the item
    ///   - media: The kind of ``Media``
    func deleteKodiItem(itemID: Library.ID, media: Library.Media) {
        Task { @MainActor in
            switch media {
            case .artist:
                if let index = library.artists.firstIndex(where: { $0.artistID == itemID }) {
                    library.artists.remove(at: index)
                }
            case .song:
                if let index = library.songs.firstIndex(where: { $0.songID == itemID }) {
                    library.songs.remove(at: index)
                }
            case .movie:
                if let index = library.movies.firstIndex(where: { $0.movieID == itemID }) {
                    library.movies.remove(at: index)
                }
            case .tvshow:
                if let index = library.tvshows.firstIndex(where: { $0.tvshowID == itemID }) {
                    library.tvshows.remove(at: index)
                }
            case .episode:
                if let index = library.episodes.firstIndex(where: { $0.episodeID == itemID }) {
                    library.episodes.remove(at: index)
                }
            case .musicVideo:
                if let index = library.musicVideos.firstIndex(where: { $0.musicVideoID == itemID }) {
                    library.musicVideos.remove(at: index)
                }
            default:
                Logger.library.warning("Library delete for \(media.description) not implemented.")
            }
            Logger.library.notice("Removed \(media.description) \(itemID) from the library")
            /// Store the library in the cache
            await setLibraryCache()
        }
    }
}
