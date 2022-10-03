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
    
    /// Mark a ``KodiItem`` as new
    /// - Note: You can't set the date to nil or empty; that will be ignored, so we set it to a long time ago if needed
    func markAsNew() async {
        var newItem = self
        newItem.playcount = 0
        newItem.resume.position = 0
        newItem.lastPlayed = "2000-01-01 00:00:00"
        await setDetails(newItem)
    }
    
    /// Toggle the played status of a ``KodiItem``
    /// - Note: You can't set the date to nil or empty; that will be ignored, so we set it to a long time ago if needed
    func togglePlayedState() async {
        switch self.playcount {
        case 0:
            await self.markAsPlayed()
        default:
            await self.markAsNew()
        }
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
        case let movieSet as Video.Details.MovieSet:
            await movieSetDetails(set: movieSet)
        case let tvshow as Video.Details.TVShow:
            await tvshowDetails(tvshow: tvshow)
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
    
    func movieSetDetails(set: Video.Details.MovieSet) async {
        let setDetails = await VideoLibrary.getMovieSetDetails(setID: set.setID)
        if let movies = setDetails.movies {
            for movie in movies {
                var update = await VideoLibrary.getMovieDetails(movieID: movie.movieID)
                update.playcount = set.playcount
                update.lastPlayed = set.lastPlayed
                update.resume = set.resume
                await VideoLibrary.setMovieDetails(movie: update)
            }
        }
    }
    
    func tvshowDetails(tvshow: Video.Details.TVShow) async {
        var episodes = await VideoLibrary.getEpisodes(tvshowID: tvshow.tvshowID)
        for (index, _) in episodes.enumerated() {
            episodes[index].playcount = tvshow.playcount
            episodes[index].lastPlayed = tvshow.lastPlayed
            episodes[index].resume.position = tvshow.resume.position
            await VideoLibrary.setEpisodeDetails(episode: episodes[index])
        }
        await VideoLibrary.setTVShowDetails(tvshow: tvshow)
    }
}
