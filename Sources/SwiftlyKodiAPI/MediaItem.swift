//
//  MediaItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// The struct for a media item from the Kodi library
///
/// Anything inside the Kodi library is a ``MediaItem``;
/// movies, movie sets, tv shows, episodes, music videos, artists, albums, songs and genres.
///
/// Depending on the ``MediaType``, the variables will be empty or filled in.
///
/// - Tip: The are no `optionals`. When a variable is not found or empty,
/// a String will be `""`, an Int will be `0` and an Array will be `[]`.
public struct MediaItem: Codable, Identifiable, Equatable, Hashable {

    /// # General
    
    /// The indentifiation of the item
    /// - Note: tvOS doesn't like `UUID`'s for this for some unknown reason
    public var id: String = ""

    /// The kind of ``MediaType``
    public var media: MediaType = .none
    
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
    public var sorttitle: String = ""
    
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
    
    /// The country of the item
    public var country: [String] = []
    
    /// The rating for the item
    public var rating: Int = 0
    
    /// The cast of the item
    public var cast: [ActorItem] = []
    
    /// The items an item contains
    /// - Movie Set: Count of movies in the set
    /// - Music Video Album: Count of music videos in the album
    /// - Artist: Count of albums of the artist
    /// - Album: Count of songs in the album
    public var itemsCount: Int = 0
    
    /// # File
    
    /// The full URL of the item
    public var file: String = ""
    /// The playcount of the item
    public var playcount: Int = 0
    
    /// # Date and Time

    /// Runtime of the item; in seconds
    public var runtime: Int = 0
    /// Duration of the item; presented as a formatted `runtime`
    //public var duration: String = ""
    /// The release date of the item
    /// - Note: In case of an Episode, it is the 'first-aired' date
    public var releaseDate: String = ""
    /// The release year of the item
    public var releaseYear: String = ""
    /// The date the item was added to the Kodi database
    public var dateAdded: String = ""
    /// The date the item was last played
    public var lastPlayed: String = ""
    
    /// # Art
    
    /// The poster for the item
    public var poster: String = ""
    /// The fanart for the item
    public var fanart: String = ""
    /// The thumbnail for the item
    /// - Note: Used in episodes
    public var thumbnail: String = ""
    
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
    public var musicVideoID: Int = 0
    /// The artist ID
    public var artistID: Int = 0
    /// The artist ID's
    /// - Note: For albums and songs
    public var artistIDs: [Int] = []
    /// The album ID
    public var albumID: Int = 0
    /// The song ID
    public var songID: Int = 0
    
    /// # Video
    
    /// The stream details of the video item
    public var streamDetails = Video.Streams()
    
    
    /// # Movies
    
    /// The title of the movie set a movie might belong
    var movieSetTitle = ""
    
    /// # TV shows and Episodes
    
    /// The total seasons for a TV show
    public var seasons: [Int] = []
    /// The season number
    public var season: Int = 0
    /// The episode number
    public var episode: Int = 0
    /// The name of the TV show
    public var showTitle: String = ""
    
    /// # Music
    
    /// An array of artists
    public var artists: [String] = []
    /// Album title
    public var album: String = ""
    /// Track number
    public var track: Int = 0
    /// The sort title of the album artist (album item)
    public var sortartist: String = ""
    /// Compilation
    ///  - Artist: Not an album artist
    ///  - Album: Compilation album
    ///  - Song: Part of a compilatin album
    public var compilation: Bool = false
}

// MARK: Calcutated stuff

extension MediaItem {

    /// Duration of the item; presented as a formatted `runtime`
    public var duration: String {
        let formatter = DateComponentsFormatter()
        /// - Note: When runtime is more than an hour, make it HH:MM, else MM:SS
        formatter.allowedUnits = runtime > 599 ? [.hour, .minute] : [.minute, .second]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(runtime))!
    }
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
