//
//  Library+Details.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Library {
    
    /// Fields for Library details
    struct Details {
        
        struct Genre: Codable {
            var genreID: Int = 0
            /// var sourceID: [Int] = []
            var thumbnail: String = ""
            var title: String = ""
            
            enum CodingKeys: String, CodingKey {
                case genreID = "genreid"
                /// case sourceID = "sourceid"
                case thumbnail
                case title
            }
            
        }
        
        /// The properties of a genre
        static let genre = [
            "title",
            "thumbnail",
            "sourceid"
        ]
    }
}
