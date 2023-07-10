//
//  VideoLibrary+Episodes+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Array where Element == Video.Details.Episode {

    /// Swap episodes for seasons
    /// - Parameter tvshow: The TV show
    /// - Returns: An array of ``Video/Details/Season``
    public func swapEpisodesForSeasons(tvshow: Video.Details.TVShow) -> [Video.Details.Season] {
        var seasons: [Video.Details.Season] = []
        /// Filter the episodes to get the seasons
        let allSeasons = self.unique { $0.season }
        /// Find the playcount of the season
        for season in allSeasons {
            let episodes = self.filter { $0.season == season.season }
            seasons.append(
                Video.Details.Season(tvshow: tvshow, episodes: episodes)
            )
        }
        return seasons
    }
}
