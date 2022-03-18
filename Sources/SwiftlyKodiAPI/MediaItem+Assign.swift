//
//  MediaItem+Assign.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Set the variables for the ``MediaItem``
    ///
    /// - Parameters:
    ///   - item: The ``KodiResponse`` array from the JSON request
    ///   - media: The ``MediaType`` for this item
    /// - Returns: A ``MediaItem`` array with the variables set
    func setMediaItem(items: [KodiResponse], media: MediaType) -> [MediaItem] {
        var mediaItems: [MediaItem] = []
        for item in items {
            /// Basic stuff
            var mediaItem = MediaItem(media: media,
                                      description: item.description,
                                      genres: item.genre,
                                      rating: item.rating,
                                      file: item.filePath,
                                      playcount: item.playcount,
                                      runtime: item.runtime,
                                      releaseDate: item.releaseDate,
                                      releaseYear: item.releaseYear,
                                      dateAdded: item.dateAdded,
                                      lastPlayed: item.lastPlayed,
                                      poster: item.poster,
                                      fanart: item.fanart,
                                      artistIDs: item.artistIDs,
                                      compilation: item.compilation
            )
            /// Build the default`details`
            let details = item.genre + [item.releaseYear] + [mediaItem.duration]
            mediaItem.details = details.joined(separator: "・")
            /// Add additional Media specific stuff
            switch media {
            case .movie:
                /// # Movies
                mediaItem.id = "movie-\(item.movieID)"
                mediaItem.movieID = item.movieID
                mediaItem.movieSetID = item.movieSetID
                mediaItem.title = item.title
                mediaItem.sorttitle = item.sorttitle
                mediaItem.subtitle = item.tagline
                mediaItem.movieSetTitle = item.movieSetTitle
            case .movieSet:
                /// # Movie sets
                mediaItem.id = "movieset-\(item.movieSetID)"
                mediaItem.movieSetID = item.movieSetID
                mediaItem.title = item.title
                mediaItem.description = item.description.isEmpty ? "Movie Set" : item.description
                mediaItem.addMovieSetFields()
                ///  - Note: Some additional fields will be filled-in by the `getMovies` function
            case .tvshow:
                /// # TV Show
                mediaItem.id = "tvshow-\(item.tvshowID)"
                mediaItem.tvshowID = item.tvshowID
                mediaItem.title = item.title
                mediaItem.subtitle = "\(item.episode) episodes"
                /// Build the `details`
                let details = item.genre + [item.releaseYear] + item.studio
                mediaItem.details = details.joined(separator: "・")
            case .episode:
                /// # Episode
                mediaItem.id = "episode-\(item.episodeID)"
                mediaItem.episodeID = item.episodeID
                mediaItem.tvshowID = item.tvshowID
                mediaItem.title = item.title
                mediaItem.subtitle = item.showtitle
                mediaItem.season = item.season
                mediaItem.episode = item.episode
                /// Build the `details
                let details = ["Episode \(item.episode)"] + ["Aired \(item.releaseDate.kodiDate().formatted(date: .abbreviated, time: .omitted))"]
                mediaItem.details = details.joined(separator: "・")
            case .musicVideo:
                /// # Music Video
                mediaItem.id = "musicvideo-\(item.musicVideoID)"
                mediaItem.musicVideoID = item.musicVideoID
                mediaItem.title = item.title
                mediaItem.subtitle = item.artists.joined(separator: " & ")
                mediaItem.artists = item.artists
                mediaItem.album = item.album
                mediaItem.track = item.track
            case .artist:
                /// # Artist
                mediaItem.id = "artist-\(item.artistID)"
                mediaItem.artistID = item.artistID
                mediaItem.title = item.artists.joined(separator: " & ")
                mediaItem.subtitle = item.artistGenres.map { $0.title } .joined(separator: "・")
                mediaItem.sorttitle = item.sortname
                mediaItem.artists = item.artists
            case .album:
                /// # Album
                mediaItem.id = "album-\(item.albumID)"
                mediaItem.albumID = item.albumID
                mediaItem.title = item.title
                mediaItem.subtitle = item.artists.joined(separator: " & ")
                mediaItem.artists = item.artists
                mediaItem.sortartist = item.sortartist
                mediaItem.addAlbumFields()
            case .song:
                /// # Song
                mediaItem.id = "song-\(item.songID)"
                mediaItem.songID = item.songID
                mediaItem.artistID = item.artistID
                mediaItem.albumID = item.albumID
                mediaItem.title = item.title
                mediaItem.subtitle = item.artists.joined(separator: " & ")
                mediaItem.addSongFields()
            default:
                /// # None
                mediaItem.media = .none
                mediaItem.id = UUID().uuidString
            }
            /// Add it to the media library
            mediaItems.append(mediaItem)
        }
        return mediaItems
    }
}
