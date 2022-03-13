//
//  File.swift
//  
//
//  Created by Nick Berendsen on 12/03/2022.
//

import Foundation

extension KodiConnector {

    /// Set the details for a Media item
    /// - Parameter item: The media item
    func setMediaItemDetails(item: MediaItem) {
        Task {
            switch item.media {
            case .movie:
                await setMovieDetails(movie: item)
            case .song:
                await setSongDetails(song: item)
            default:
                break
            }
        }
    }
    
    func updateMediaItemDetails(itemID: Int, type: MediaType) {
        
        Task { @MainActor in
            
            if let index = media.firstIndex(where: {$0.id == "\(type)-\(itemID)"}) {
                logger("Going to update \(media[index].title)")
                
                switch media[index].media {
                case .movie:
                    media[index] = await getMovieDetails(movieID: media[index].movieID)
                case .song:
                    media[index] = await getSongDetails(songID: media[index].songID)
                default:
                    break
                }
                
                logger("Updated \(media[index].title)")
                storeMediaInCache(media: media)
            }
        }
    }
}
