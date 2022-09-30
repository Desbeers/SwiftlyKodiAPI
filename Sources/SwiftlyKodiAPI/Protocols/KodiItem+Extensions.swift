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
        newItem.lastPlayed = kodiDateFromSwiftDate(Date())
        newItem.resume.position = 0
        await setDetails(newItem)
    }
    
    /// Set the resume time of a  ``KodiItem``
    func setResumeTime(time: Double) async {
        var newItem = self
        newItem.resume.position = Double(Int(time))
        newItem.lastPlayed = kodiDateFromSwiftDate(Date())
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
        
        newItem.resume.position = 0
        
        newItem.playcount = self.playcount == 0 ? 1 : 0
        /// Set or reset the last played date
        newItem.lastPlayed = newItem.playcount == 0 ? "2000-01-01 00:00:00" : kodiDateFromSwiftDate(Date())
        switch self.media {
        case .tvshow:
            /// Update the episodes with the new playcount
            let kodi: KodiConnector = .shared
            if let tvshow = kodi.library.tvshows.first(where: {$0.id == self.id}) {
                var episodes = kodi.library.episodes.filter {
                    $0.tvshowID == tvshow.tvshowID &&
                    $0.playcount != newItem.playcount
                }
                for (index, _) in episodes.enumerated() {
                    episodes[index].playcount = newItem.playcount
                    episodes[index].lastPlayed = newItem.lastPlayed
                    await VideoLibrary.setEpisodeDetails(episode: episodes[index])
                }
            }
        default:
            break
        }
        await setDetails(newItem)
    }
}

extension KodiItem {
    
    /// Convert a `Date` to a Kodi date string
    /// - Parameter date: The `Date`
    /// - Returns: A string with the date
    func kodiDateFromSwiftDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
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
