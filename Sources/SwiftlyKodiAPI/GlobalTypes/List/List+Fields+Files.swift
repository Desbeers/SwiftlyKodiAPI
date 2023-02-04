//
//  List+Fields+Files.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension List.Fields {

    /// All List fields for files (Global Kodi Type)
    static let files = [
        "lastmodified",
        "lastplayed",
        "playcount",
        /// Watched episodes for TV show
        /// - Note: To get updates; this value will be observed
        "watchedepisodes"
    ]
}
