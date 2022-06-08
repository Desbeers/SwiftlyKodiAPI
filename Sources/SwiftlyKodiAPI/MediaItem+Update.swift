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
            case .movie:
                await setMovieDetails(movie: item)
            case .tvshow:
                await setTVShowDetails(tvshow: item)
            case .episode:
                await setEpisodeDetails(episode: item)
            case .musicVideo:
                await setMusicVideoDetails(musicVideo: item)
            case .song:
                await setSongDetails(song: item)
            default:
                logger("Set details for '\(item.media)' not implemented")
            }
        }
    }
    
    /// Get de details for a media item and update the local cache
    /// - Parameters:
    ///   - itemID: Te ID of the medi item
    ///   - type: The ``MediaType`` of the media item
    func getMediaItemDetails(itemID: Int, type: MediaType) {
        Task { @MainActor in
            if let index = media.firstIndex(where: {$0.id == "\(type.rawValue)-\(itemID)"}) {
                switch media[index].media {
                case .movie:
                    media[index] = await getMovieDetails(movieID: media[index].movieID)
                case .tvshow:
                    media[index] = await getTVShowDetails(tvshowID: media[index].tvshowID)
                case .episode:
                    media[index] = await getEpisodeDetails(episodeID: media[index].episodeID)
                case .musicVideo:
                    media[index] = await getMusicVideoDetails(musicVideoID: media[index].musicVideoID)
                case .song:
                    media[index] = await getSongDetails(songID: media[index].songID)
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
