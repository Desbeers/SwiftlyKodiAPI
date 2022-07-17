//
//  KodiItem+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension KodiItem {
    
    /// Mark a ``KodiItem`` as played
    func markAsPlayed() async {
        
        var newItem = self
        
        newItem.playcount += 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newItem.lastPlayed = dateFormatter.string(from: Date())
        
        await setDetails(newItem)
    }
    
    /// Toggle a ``KodiItem`` as 'favorite'
    ///
    /// This will set the 'userRating' to either 10 or 0
    func toggleFavorite() async {

        var newItem = self

        newItem.userRating = self.userRating < 10 ? 10 : 0

        await setDetails(newItem)
    }
    
    /// Toggle the played status of a ``KodiItem``
    /// - Note: You can't set the date to nil or empty; that will be ignored, so we set it to a long time ago if needed
    func togglePlayedState() async {
        logger("Toggle play state")
        
        var newItem = self
        
        newItem.playcount = self.playcount == 0 ? 1 : 0
        /// Set or reset the last played date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newItem.lastPlayed = newItem.playcount == 0 ? "1900-01-01 00:00:00" : dateFormatter.string(from: Date())
        
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

extension KodiItem {
    
    /// Set the details of a ``KodiItem``
    /// - Parameter item: The ``KodiItem`` to set
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
    }
}
