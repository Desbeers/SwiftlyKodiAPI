//
//  File.swift
//  
//
//  Created by Nick Berendsen on 12/03/2022.
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
            case .episode:
                await setEpisodeDetails(episode: item)
            case .musicVideo:
                await setMusicVideoDetails(musicVideo: item)
            case .song:
                await setSongDetails(song: item)
            default:
                break
            }
        }
    }
    
    /// Get de details for a media item
    /// - Parameters:
    ///   - itemID: Te ID of the medi item
    ///   - type: The ``MediaType`` of the media item
    func updateMediaItemDetails(itemID: Int, type: MediaType) {
        print(type)
        Task { @MainActor in
            if let index = media.firstIndex(where: {$0.id == "\(type.rawValue)-\(itemID)"}) {
                switch media[index].media {
                case .movie:
                    media[index] = await getMovieDetails(movieID: media[index].movieID)
                case .episode:
                    media[index] = await getEpisodeDetails(episodeID: media[index].episodeID)
                case .musicVideo:
                    media[index] = await getMusicVideoDetails(musicVideoID: media[index].musicVideoID)
                case .song:
                    media[index] = await getSongDetails(songID: media[index].songID)
                default:
                    break
                }
                logger("Updated '\(media[index].title)' in the media library")
                storeMediaInCache(media: media)
            }
            else {
                logger("Could not find '\(type)' with ID '\(itemID)'")
            }
        }
    }
}
