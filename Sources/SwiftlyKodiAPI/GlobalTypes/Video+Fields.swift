//
//  Video+Fields.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Video {
    
    /// Static fields for Video
    struct Fields {
        /// The properties of a movie set
        static let movieSet = [
            "title",
            "playcount",
            "art",
            "plot"
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
        /// The properties of  a music video
        static var musicVideo = [
            "title",
            "artist",
            "album",
            "track",
            "genre",
            "file",
            "year",
            "premiered",
            "art",
            "playcount",
            "plot",
            "runtime",
            "streamdetails",
            "dateadded",
            "lastplayed"
        ]
    }
}
