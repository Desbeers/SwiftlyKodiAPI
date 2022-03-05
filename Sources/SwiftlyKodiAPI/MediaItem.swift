//
//  File.swift
//  
//
//  Created by Nick Berendsen on 05/03/2022.
//

import Foundation

public struct MediaItem: Identifiable {
    
    /// # General
    
    /// The indentifiation of the item
    /// - Note: tvOS doesn't like `UUID`'s for this for some unknown reason
    public var id: String = ""
    /// The kind of ``KodiMedia``
    public var media: KodiMedia = .none
    /// The title of the item
    public var title: String = ""
    /// The subtitle of the item
    public var subtitle: String = ""
    /// The description of the item
    public var description: String = ""
    
    /// # File
    
    /// The full URL of the item
    public var file: String = ""
    /// The playcount of the item
    public var playcount: Int = 0
    /// Duration of the item; presented as a formatted String
    public var duration: String = ""
    /// The release date of the item
    public var releaseDate: Date = Date()
    /// The release year of the item
    public var releaseYear: String = ""
    /// The date the item was added to the Kodi database
    public var dateAdded: String = ""
    
    /// # Art
    
    /// The poster for the item
    public var poster: String = ""
    /// The fanart for the item
    public var fanart: String = ""
    
    /// # ID's

    /// The movie ID
    public var movieID: Int = 0
    /// The set ID
    public var setID: Int = 0
    /// The TV show ID
    public var tvshowID: Int = 0
    /// The episode ID
    public var episodeID: Int = 0
    /// The music video ID
    public var musicvideoID: Int = 0
    /// The artist ID
    public var artistID: Int = 0
    
    /// # Music
    
    /// An array of artists
    var artists: [String] = []
    
}
