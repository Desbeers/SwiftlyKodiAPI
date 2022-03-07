//
//  File.swift
//  
//
//  Created by Nick Berendsen on 05/03/2022.
//

import Foundation

extension KodiConnector {
    
    /// Set the variables for the ``MediaItem``
    ///
    /// - Parameters:
    ///   - item: The ``KodiItem``
    ///   - media: The ``MediaType`` type for this ``KodiItem``
    /// - Returns: The ``MediaItem``'s with the variables set
    func setMediaItem(items: [KodiItem], media: MediaType) -> [MediaItem] {
        var mediaItems: [MediaItem] = []
        for item in items {
            /// Basic stuff
            var mediaItem = MediaItem(media: media,
                                      description: item.description,
                                      genres: item.genre,
                                      file: item.fileURL,
                                      playcount: item.playcount,
                                      duration: item.duration,
                                      releaseDate: item.releaseDate,
                                      releaseYear: item.releaseYear,
                                      dateAdded: item.dateAdded,
                                      poster: item.poster,
                                      fanart: item.fanart
            )
            /// Build the default`details`
            let details = item.genre + [item.releaseYear] + [item.duration]
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
                mediaItem.id = "episode-\(item.tvshowID)-\(item.season)-\(item.episode)"
                mediaItem.episodeID = item.episodeID
                mediaItem.tvshowID = item.tvshowID
                mediaItem.title = item.title
                mediaItem.subtitle = item.showtitle
                mediaItem.season = item.season
                mediaItem.episode = item.episode
                /// Build the `details
                let details = ["Episode \(item.episode)"] + ["Aired \(item.releaseDate.kodiDate().formatted(date: .abbreviated, time: .omitted))"]
                mediaItem.details = details.joined(separator: "・")
            case .musicvideo:
                /// # Music Video
                mediaItem.id = "musicvideo-\(item.musicvideoID)"
                mediaItem.musicvideoID = item.musicvideoID
                mediaItem.title = item.title
                mediaItem.subtitle = item.artist.joined(separator: " & ")
                mediaItem.artists = item.artist
                mediaItem.album = item.album
                mediaItem.track = item.track
            case .artist:
                /// # Artist
                mediaItem.id = "artist-\(item.artistID)"
                mediaItem.artistID = item.artistID
                mediaItem.title = item.artist.joined(separator: " & ")
                mediaItem.sorttitle = item.sortname
                mediaItem.subtitle = ""
                mediaItem.artists = item.artist
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
