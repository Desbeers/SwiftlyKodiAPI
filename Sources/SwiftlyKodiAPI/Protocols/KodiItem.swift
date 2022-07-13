//
//  KodiItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public protocol KodiItem: Codable, Identifiable, Equatable, Hashable {
    /// The ID of the item
    var id: Int { get }
    /// The kind of ``Library/Media``
    var media: Library.Media { get }
    /// The title of the item
    var title: String { get }
    /// The 'sort by title' of the item
    var sortByTitle: String { get }
    /// The playcount of the item
    var playcount: Int { get set }
    /// The last played date of the item
    var lastPlayed: String { get set }
    /// The poster of the item
    var poster: String { get }
    /// The fanart of the item
    var fanart: String { get }
    /// The location of the file
    var file: String { get }
}

public extension KodiItem {
    
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

public extension KodiItem {
    
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

public extension KodiItem {
    func setDetails(_ item: any KodiItem) async {
        
        switch item {
        case let movie as Video.Details.Movie:
            await VideoLibrary.setMovieDetails(movie: movie)
        case let tvshow as Video.Details.TVShow:
            await VideoLibrary.setTVShowDetails(tvshow: tvshow)
        case let episode as Video.Details.Episode:
            await VideoLibrary.setEpisodeDetails(episode: episode)
        case let musicVideo as Video.Details.MusicVideo:
            await VideoLibrary.setMusicVideoDetails(musicVideo: musicVideo)
        case let song as Audio.Details.Song:
            await AudioLibrary.setSongDetails(song: song)
        default:
            logger("Updating \(self.media) not implemented")
        }
        
//        switch item.media {
//        case .song:
//            await AudioLibrary.setSongDetails(song: item as! Audio.Details.Song)
//        case .movie:
//            await VideoLibrary.setMovieDetails(movie: item as! Video.Details.Movie)
//        case .tvshow:
//            await VideoLibrary.setTVShowDetails(tvshow: item as! Video.Details.TVShow)
//        case .episode:
//            await VideoLibrary.setEpisodeDetails(episode: item as! Video.Details.Episode)
//        case .musicVideo:
//            await VideoLibrary.setMusicVideoDetails(musicVideo: item as! Video.Details.MusicVideo)
//        default:
//            logger("Updating \(self.media) not implemented")
//        }
    }
}
