//
//  Audio+Details+Stream.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Audio.Details {
    
    /// Stream details
    struct Stream: KodiItem {
        public init(id: Int = 1, media: Library.Media = .stream, station: String = "", description: String = "", title: String = "", subtitle: String = "", poster: String = "", playcount: Int = 0, lastPlayed: String = "", userRating: Int = 0, fanart: String = "", file: String = "") {
            self.id = id
            self.media = media
            self.station = station
            self.description = description
            self.title = title
            self.subtitle = subtitle
            self.poster = poster
            self.playcount = playcount
            self.lastPlayed = lastPlayed
            self.userRating = userRating
            self.fanart = fanart
            self.file = file
        }
        

        
        public var id: Int = 1
        
        public var media: Library.Media = .stream
        
        public var station: String = ""
        
        public var description: String = ""
        
        public var title: String = ""
        
        public var subtitle: String = ""
        
        public var sortByTitle: String { title }
        
        public var poster: String = ""

        
        public var playcount: Int = 0
        
        public var lastPlayed: String = ""
        
        public var userRating: Int = 0
        
        public var fanart: String = ""
        
        public var file: String = ""
        
    }
}
