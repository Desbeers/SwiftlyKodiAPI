//
//  List+Filter.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension List {
    /// The filter fields for JSON requests
    struct Filter: Codable {
        /// Filter by album ID
        var albumID: Int?
        /// Filter by artist ID
        var artistID: Int?
    }
}

extension List.Filter {
    /// Coding keys
    enum CodingKeys: String, CodingKey {
        case albumID = "albumid"
        case artistID = "artistid"
    }
}
