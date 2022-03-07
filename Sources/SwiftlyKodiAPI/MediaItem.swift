//
//  File.swift
//  
//
//  Created by Nick Berendsen on 05/03/2022.
//

import Foundation

/// A struct for a media item from the Kodi library
///
/// Anything inside the Kodi library is a ``MediaItem``;
/// movies, tv shows, episodes, music videos, artists, albums, songs and genres.
///
/// Depending on the ``KodiMedia``, the variables will be empty or filled in.
///
/// - Tip: The are no `optionals`. When a variable is not found or empty,
/// a String will be `""`, an Int will be `0` and an Array will be `[]`.
public struct MediaItem: Identifiable, Equatable, Hashable {
    
    /// # General
    
    /// The indentifiation of the item
    /// - Note: tvOS doesn't like `UUID`'s for this for some unknown reason
    public var id: String = ""
    //public let id = UUID().uuidString
    
    /// The kind of ``KodiMedia``
    public var media: KodiMedia = .none
    
    /// The title of the item
    /// - Movie: Movie title
    /// - Movie Set: Movie set name
    /// - TV show: TV show name
    /// - Episode: Episode title
    /// - Music Video: Music Video title
    /// - Artist: Artist name
    /// - Album: Album title
    /// - Song: Song title
    /// - Genre: Genre label
    public var title: String = ""
    
    /// The sort title of the item
    var sorttitle: String = ""
    
    /// The subtitle of the item
    /// - Movie: Movie tagline
    /// - TV show: *Not in use*
    /// - Episode: TV show name
    /// - Music Video: Artist(s) name
    /// - Artist: *Not in use*
    /// - Album: Album artist(s)
    /// - Song: Song artist(s)
    /// - Genre: *Not in use*
    public var subtitle: String = ""
    
    /// The description of the item
    public var description: String = ""
    
    /// The details of the item
    public var details: String = ""
    
    /// The genres for the item
    public var genres: [String] = []
    
    /// # File
    
    /// The full URL of the item
    public var file: URL = URL(fileURLWithPath: "")
    /// The playcount of the item
    public var playcount: Int = 0
    
    /// # Date and Time
    
    /// Duration of the item; presented as a formatted String
    public var duration: String = ""
    /// The release date of the item
    /// - Note: In case of an Episode, it is the 'first-aired' date
    public var releaseDate: String = ""
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
    public var movieSetID: Int = 0
    /// The TV show ID
    public var tvshowID: Int = 0
    /// The episode ID
    public var episodeID: Int = 0
    /// The music video ID
    public var musicvideoID: Int = 0
    /// The artist ID
    public var artistID: Int = 0
    
    /// # Movies
    
    /// The title of the movie set a movie might belong
    var movieSetTitle = ""
    
    /// # TV shows and Episodes
    
    /// The season number
    public var season: Int = 0
    /// The episode number
    public var episode: Int = 0
    
    /// # Music
    
    /// An array of artists
    public var artists: [String] = []
    /// Album title
    public var album: String = ""
    /// Track number
    public var track: Int = 0
    
}


// MARK: Sorting

extension MediaItem {
    
    var sortByTitle: String {
        sorttitle.isEmpty ? title : sorttitle
    }
    
    var sortBySetAndTitle: String {
        movieSetTitle.isEmpty ? sorttitle.isEmpty ? title : sorttitle : movieSetTitle
    }
}
