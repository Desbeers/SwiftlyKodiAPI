//
//  Video+Fields.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Video {
    /// Static fields for videos
    struct Fields {
        /// The properties of a movie
        static let movie = [
            "title",
            "sorttitle",
            "file",
            "tagline",
            "plot",
            "genre",
            "art",
            "year",
            "premiered",
            "set",
            "setid",
            "playcount",
            "runtime",
            "cast",
            "country",
            "streamdetails",
            "dateadded",
            "lastplayed"
        ]
        /// The properties of a movie set
        static let movieSet = [
            "title",
            "playcount",
            "art",
            "plot"
        ]
        /// The properties of  a tv show
        static var tvshow = [
            "title",
            "sorttitle",
            "file",
            "plot",
            "genre",
            "art",
            "year",
            "premiered",
            "playcount",
            "dateadded",
            "studio",
            "episode",
            "lastplayed"
        ]
        /// The properties of  an episode
        static var episode = [
            "title",
            "plot",
            "playcount",
            "season",
            "episode",
            "art",
            "file",
            "showtitle",
            "firstaired",
            "runtime",
            "cast",
            "tvshowid",
            "streamdetails",
            "lastplayed"
        ]
    }
}
