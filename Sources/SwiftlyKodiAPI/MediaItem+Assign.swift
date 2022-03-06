//
//  File.swift
//  
//
//  Created by Nick Berendsen on 05/03/2022.
//

import Foundation

extension KodiConnector {
    /// Set the kind of media for the ``KodiItem``
    ///
    /// A ``KodiItem`` can be of the following type:
    /// - Movie
    /// - TV show
    /// - Episode
    /// - Music Video
    ///
    /// - Parameters:
    ///   - item: The ``KodiItem``
    ///   - media: The ``KodiMedia`` type for this ``KodiItem``
    /// - Returns: The ``KodiItem``'s with the ``KodiMedia`` set
    func setMediaItem(items: [KodiItem], media: KodiMedia) -> [MediaItem] {
        var MediaItems: [MediaItem] = []
        for item in items {
            /// Basic stuff
            var mediaItem = MediaItem(media: media,
                                      description: item.description,
                                      details: "DETAILS",
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
            
            switch media {
            case .movie:
                
                
                mediaItem.id = "movie-\(item.movieID)"
                mediaItem.movieID = item.movieID
                mediaItem.movieSetID = item.setID
                mediaItem.title = item.title
                mediaItem.subtitle = item.tagline
                mediaItem.movieSetTitle = item.movieSetTitle
                
            case .movieSet:

                mediaItem.id = "movieSet-\(item.setID)"
                mediaItem.movieSetID = item.setID
                mediaItem.title = item.title
                mediaItem.subtitle = ""
                
            case .tvshow:
                
                mediaItem.id = "tvshow-\(item.tvshowID)"
                mediaItem.tvshowID = item.tvshowID
                mediaItem.title = item.title
                mediaItem.subtitle = ""
                
            case .episode:
                
                mediaItem.id = "episode-\(item.tvshowID)-\(item.season)-\(item.episode)"
                mediaItem.episodeID = item.episodeID
                mediaItem.tvshowID = item.tvshowID
                mediaItem.title = item.title
                mediaItem.subtitle = item.showtitle
                mediaItem.season = item.season
                mediaItem.episode = item.episode
                
            case .musicvideo:
                
                mediaItem.id = "musicvideo-\(item.musicvideoID)"
                mediaItem.musicvideoID = item.musicvideoID
                mediaItem.title = item.title
                mediaItem.subtitle = item.artist.joined(separator: " & ")
                mediaItem.artists = item.artist
                
            case .artist:
                
                mediaItem.id = "artist-\(item.artistID)"
                mediaItem.artistID = item.artistID
                mediaItem.title = item.artist.joined(separator: " & ")
                mediaItem.subtitle = ""
                mediaItem.artists = item.artist
                
            default:
                mediaItem.media = .none
                mediaItem.id = UUID().uuidString
            }
            /// Add it to the media library
            MediaItems.append(mediaItem)
        }
        return MediaItems
    }
}
