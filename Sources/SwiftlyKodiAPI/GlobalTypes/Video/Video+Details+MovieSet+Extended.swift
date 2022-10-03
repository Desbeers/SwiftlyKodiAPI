//
//  Video+Details+MovieSet+Extended.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Video.Details.MovieSet {
    
    /// Movies in a movie set
    /// - Note: Only used for 'VideoLibrary.GetMovieSetDetails'
    struct Extended: Codable, Identifiable, Hashable {
        
        public var id: Library.id { movieID }
        public var label: String = ""
        public var movieID: Library.id = 0
        
        enum CodingKeys: String, CodingKey {
            case label
            case movieID = "movieid"
        }
        
    }
}
