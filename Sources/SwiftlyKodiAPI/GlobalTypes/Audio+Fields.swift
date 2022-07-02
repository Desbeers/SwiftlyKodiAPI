//
//  Audio+Fields.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Audio {
    /// Static fields for audio
    struct Fields {
        /// The properties of an album
        static let album = [
            "artistid",
            "artist",
            "sortartist",
            "description",
            "title",
            "year",
            "playcount",
            "totaldiscs",
            "genre",
            "art",
            "compilation",
            "dateadded",
            "lastplayed",
            "albumduration"
        ]
        /// The properties of an artist
        static let artist = [
            
            "instrument",
            "style",
            "mood",
            "born",
            "formed",
            "description",
            "genre",
            "died",
            "disbanded",
            "yearsactive",
            "musicbrainzartistid",
            "fanart",
            "thumbnail",
            "compilationartist",
            "dateadded",
            "roles",
            "songgenres",
            "isalbumartist",
            "sortname",
            "type",
            "gender",
            "disambiguation",
            "art",
            "sourceid",
            "datemodified",
            "datenew"
            
//            "art",
//            "description",
//            "sortname",
//            "isalbumartist",
//            "songgenres"
        ]
        /// The properties of a song
        static var song = [
            "title",
            "artist",
            "artistid",
            "albumid",
            "comment",
            "year",
            "playcount",
            "track",
            "disc",
            "lastplayed",
            "album",
            "genreid",
            "dateadded",
            "genre",
            "duration",
            "userrating",
            "file",
            "art"
        ]
    }
}
