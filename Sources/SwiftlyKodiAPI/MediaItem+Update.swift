//
//  MediaItem+Update.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Set the details for a Media item
    /// - Parameter item: The media item we want to set
    func setMediaItemDetails(item: MediaItem) {
        Task.detached { [self] in 
            switch item.media {
//            case .movie:
//                await VideoLibrary.setMovieDetails(movie: item)
            case .tvshow:
                await VideoLibrary.setTVShowDetails(tvshow: item)
//            case .episode:
//                await VideoLibrary.setEpisodeDetails(episode: item)
            case .musicVideo:
                await VideoLibrary.setMusicVideoDetails(musicVideo: item)
//            case .song:
//                await AudioLibrary.setSongDetails(song: item)
            default:
                logger("Set details for '\(item.media)' not implemented")
            }
        }
    }
    
    /// Get de details for a media item and update the local cache
    /// - Parameters:
    ///   - itemID: The ID of the media item
    ///   - type: The ``MediaType`` of the media item
    func getMediaItemDetails(itemID: Int, type: Library.Media) {
        Task { @MainActor in
            if let index = media.firstIndex(where: {$0.id == "\(type.rawValue)-\(itemID)"}) {
                switch media[index].media {
//                case .movie:
//                    media[index] = await VideoLibrary.getMovieDetails(movieID: media[index].movieID)
//                    /// Always check the Movie Set when a Movie is part of a Set
//                    if media[index].movieSetID != 0 {
//                        getMediaItemDetails(itemID: media[index].movieSetID, type: .movieSet)
//                    }
                case .movieSet:
                    media[index] = await VideoLibrary.getMovieSetDetails(movieSetID: media[index].movieSetID)
                case .tvshow:
                    media[index] = await VideoLibrary.getTVShowDetails(tvshowID: media[index].tvshowID)
//                case .episode:
//                    media[index] = await VideoLibrary.getEpisodeDetails(episodeID: media[index].episodeID)
//                    /// Always check the TV show when an episode changed
//                    getMediaItemDetails(itemID: media[index].tvshowID, type: .tvshow)
                case .musicVideo:
                    media[index] = await VideoLibrary.getMusicVideoDetails(musicVideoID: media[index].musicVideoID)
//                case .song:
//                    media[index] = await AudioLibrary.getSongDetails(songID: media[index].songID)
                default:
                    logger("Update for '\(type)' not implemented")
                }
                logger("Updated \(type): '\(media[index].title)'")
                storeMediaInCache(media: media)
            }
            else {
                logger("Could not find '\(type)' with ID '\(itemID)'")
            }
        }
    }
}
