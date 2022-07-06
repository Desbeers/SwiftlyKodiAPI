//
//  LibraryItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public protocol LibraryItem: Codable, Identifiable, Equatable {
    /// The ID of the item
    var id: Int { get }
    /// The kind of ``Library/Media``
    var media: Library.Media { get }
    /// The playcount of the item
    var playcount: Int { get set }
    /// The last played date of the item
    var lastPlayed: String { get set }
    /// The loctation of the file
    var file: String { get }
}

public extension LibraryItem {
    
    /// Mark a ``LibraryItem`` as played
    func markAsPlayed() async {
        
        var newItem = self
        
        newItem.playcount += 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newItem.lastPlayed = dateFormatter.string(from: Date())
        
        await setDetails(newItem)
    }
}

public extension LibraryItem {
    
    /// Toggle the played status of a ``LibraryItem``
    func togglePlayedState() async {
        logger("Toggle play state")
        
        var newItem = self
        
        newItem.playcount = self.playcount == 0 ? 1 : 0
        /// Set or reset the last played date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newItem.lastPlayed = self.playcount == 0 ? "" : dateFormatter.string(from: Date())
        
        switch self.media {
        case .tvshow:
            /// Update the episodes with the new playcount
            let kodi: KodiConnector = .shared
            var episodes = kodi.library.episodes.filter {
                $0.tvshowID == self.id &&
                $0.playcount != newItem.playcount
            }
            for (index, _) in episodes.enumerated() {
                episodes[index].playcount = newItem.playcount
                episodes[index].lastPlayed = newItem.lastPlayed
                await VideoLibrary.setEpisodeDetails(episode: episodes[index])
            }
        default:
            break
        }
        await setDetails(newItem)
    }
}

public extension LibraryItem {
    func setDetails(_ item: any LibraryItem) async {
        switch item.media {
        case .song:
            await AudioLibrary.setSongDetails(song: item as! Audio.Details.Song)
        case .movie:
            await VideoLibrary.setMovieDetails(movie: item as! Video.Details.Movie)
        case .tvshow:
            await VideoLibrary.setTVShowDetails(tvshow: item as! Video.Details.TVShow)
        case .episode:
            await VideoLibrary.setEpisodeDetails(episode: item as! Video.Details.Episode)
        default:
            logger("Updating \(self.media) not implemented")
        }
    }
}
