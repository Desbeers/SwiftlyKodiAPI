//
//  PlayedState.swift
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    func setPlayedState(item: MediaItem) {
        switch item.media {
        case .tvshow:
            /// All episodes have to be checked and changed if needed
            /// and then the TV show item must be updated.
            ///
            /// Get all episodes that don't match with the TV show playcount and match it
            let episodes = media.filter {
                $0.media == .episode &&
                $0.tvshowID == item.tvshowID &&
                $0.playcount != item.playcount
            }
            /// Update the episodes
            for (index, _) in episodes.enumerated() {
                episodes[index].togglePlayedState()
            }
//            /// Update the TV show item
//            if let index = media.firstIndex(where: {$0.id == item.id}) {
//                media[index] = item
//                storeMediaInCache(media: media)
//                logger("Updated \(item.media): '\(media[index].title)'")
//            }
        case .movieSet:
            let movies = media.filter {
                $0.media == .movie &&
                $0.movieSetID == item.movieSetID &&
                $0.playcount != item.playcount
            }
            /// Update the movies
            for (index, _) in movies.enumerated() {
                movies[index].togglePlayedState()
            }
            
        default:
            /// All other ``MediaType``s
            setMediaItemDetails(item: item)
        }
    }
}

extension MediaItem {
    
    /// Toggle the played status of a ``MediaItem``.
    public func togglePlayedState() {
        logger("Toggle play state")
        
        var newItem = self
        
        newItem.playcount = self.playcount == 0 ? 1 : 0
        /// Set or reset the last played date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newItem.lastPlayed = self.playcount == 0 ? "" : dateFormatter.string(from: Date())
        
        KodiConnector.shared.setPlayedState(item: newItem)
        
        
    }
}

extension MediaItem {
    
    /// Mark a ``MediaItem`` as played
    ///
    /// In Kodi, an item is marked as played if the playcount is greater than zero.
    ///
    /// This mutating function will add one to the total playcount and update the Kodi database.
    public func markAsPlayed() {
        
        var newItem = self
        
        newItem.playcount += 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newItem.lastPlayed = dateFormatter.string(from: Date())
        KodiConnector.shared.setPlayedState(item: newItem)
    }
}
