//
//  KodiItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: Variables

/// The struct for an item as response to a JSON request
///
/// This takes are of *all* responses from Kodi when requesting items
/// from the library. It has a custom `Init` will all posible parameters
/// we might ask from Kodi.
///
/// The result will be added to ``MediaItem``'s by their respectifly callers.
///
/// This `Struct` will not take care of that because that will be messy,
/// the list is already long enough...
struct KodiResponse: Decodable {

    /// # General stuff
    
    /// Title of the item
    var title: String = ""
    
    /// The sorttitle of the item; can be empty
    /// - Note: Kodi is using `sortname` for artists but that will be assigned to this one
    var sorttitle: String = ""

    /// The sortname of an artist; can be empty
    var sortname: String = ""
    
    /// The description of the item
    /// - Note: This can be a 'real' description or a plot; both will be stored as 'description`
    var description: String = ""
    
    /// The playcount of the item
    var playcount: Int = 0
    
    /// Plot of the item
    var plot: String = ""
    
    /// Genre for the item
    var genre: [String] = []
    
    /// The rating for the item
    public var rating: Int = 0
    
    /// Tagline of the item (movie)
    var tagline: String = ""
    
    /// Runtime of the item
    var runtime: Int = 0
    
    /// Location of the item
    /// - Note: This is an internal location; not a full path
    var file: String = ""
    
    /// The full path of the item
    ///
    /// Movie Sets and Genres have no path
    ///
    /// - Note: The path from the Kodi database is *not* a full path
    /// and must be converted first
    var filePath: String {
        return getFilePath(file: file, type: .file)
    }
    
    /// # Date and Time stuff
    
    /// The year of release of the item
    var year: Int = 0
    
    /// The premiered date of the item
    var premiered: String = ""
    
    /// The first aired date of the item (episode item)
    var firstAired: String = ""
    
    /// Lat played date
    var lastPlayed: String = ""
    
    /// The full release date of the item
    /// - Note: An episode has no release date, but a first-aired date.
    ///         The JSON decoder takes care of the mapping
    var releaseDate: String {
        return premiered.isEmpty ? year.description + "-01-01" : premiered
    }
    
    /// The release year of the item
    var releaseYear: String {
        let components = Calendar.current.dateComponents([.year], from: releaseDate.kodiDate())
        return components.year?.description ?? "0000"
    }
    
    /// The date the item was added to the Kodi database
    var dateAdded: String = ""
    
    /// # Video stuff
    
    /// The cast of the item (movie and episode)
    var cast: [ActorItem] = []

    /// # Movie stuff

    /// The optional title of the movie set a movie belongs to (movie item
    /// - Note: The function that loads movie items will fill this in
    var movieSetTitle: String = ""
    
    /// The country of the item
    var country: [String] = []
    
    /// The stream detals for the item
    var streamDetails: StreamDetails = StreamDetails()
    
    /// # TV show and Episode stuff
    
    /// The studio of a TV show (tvshow item)
    var studio: [String] = []
    
    /// The title of a TV show (episode item)
    var showtitle: String = ""
    
    /// The episode number of the TV show
    var episode: Int = 0
    
    /// The season of the TV show
    var season: Int = 0
    
    /// # Music stuff
    
    /// The artist of the item (artist or music video item)
    /// - Note: JSON can give a String or an Array; the decoder takes care of that
    ///         and we just keep it as an Array because that is the most common
    var artists: [String] = []
    
    /// Tthe sorting of artist (album item)
    var sortartist: String = ""
    
    /// The name of an album (album or song item)
    var album: String = ""

    /// The genres from the artist (artist item
    /// - Note: Kodo named this `songgenres`; the decoder will map it
    var artistGenres: [ArtistGenre] = []
    
    /// The track of an item  (music video, album or song item)
    var track: Int = 0
    /// Is the item a compilation or nor
    var compilation: Bool = false
    
    /// # Art stuff
    
    /// Art of the item
    var art: [String: String] = [:]
    
    /// The poster of the item
    var poster: String {
        return getSpecificArt(art: art, type: .poster)
    }
    
    /// The fanart for the item
    var fanart: String {
        return getSpecificArt(art: art, type: .fanart)
    }
    
    /// The thumbnail for the item
    var thumbnail: String {
        return getSpecificArt(art: art, type: .thumbnail)
    }
    
    /// # ID's of items

    /// The movie ID
    public var movieID: Int = 0
    
    /// The movie set ID
    public var movieSetID: Int = 0
    
    /// The TV show ID
    public var tvshowID: Int = 0
    
    /// The episode ID
    public var episodeID: Int = 0
    
    /// The music video ID
    public var musicVideoID: Int = 0
    
    /// The artist ID (artist item)
    public var artistID: Int = 0
    
    /// The artist IDs (album item)
    public var artistIDs: [Int] = []
    
    /// The album ID
    public var albumID: Int = 0
    
    /// The song ID
    public var songID: Int = 0

}

// MARK: Coding keys

extension KodiResponse {
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        /// The public keys
        case title, description, playcount, episode, season, cast, artist, country
        
        case sortartist, compilation
        
        /// Camel Case
        case albumDuration = "albumduration"
        
        case isAlbumArtist = "isalbumartist"
        
        case streamDetails = "streamdetails"
        
        /// Song duration
        case duration
        /// Rating of the item
        case userrating
        
        /// Camel Case
        case movieSetTitle = "set"
        /// # The public ID's
        /// Camel Case
        case movieID = "movieid"
        /// Camel Case
        case movieSetID = "setid"
        /// Camel Case
        case tvshowID = "tvshowid"
        /// Camel Case
        case episodeID = "episodeid"
        /// Camel Case
        case musicVideoID = "musicvideoid"
        /// Camel Case
        case artistID = "artistid"
        /// Camel Case
        case albumID = "albumid"
        /// Camel Case
        case songID = "songid"
        /// lowerCamelCase
        case dateAdded = "dateadded"
        /// lowerCamelCase
        case lastPlayed = "lastplayed"
        /// lowerCamelCase
        case firstAired = "firstaired"
        /// Genres from an artist
        case artistGenres = "songgenres"
        /// # The internal keys
        /// Keys that are not exposed outside of the package
        case plot, tagline, genre, studio, showtitle, year, premiered, art, runtime, sorttitle, sortname, file
        /// # Audio
        case album, track
    }
}

// MARK: Init

extension KodiResponse {
    /// In an extension so we can still use the memberwise initializer.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        /// # General stuff
        
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        
        sorttitle = try container.decodeIfPresent(String.self, forKey: .sorttitle) ?? ""
        
        /// - Note: description can either be a plot or a real description
        /// Check first for plot
        description = try container.decodeIfPresent(String.self, forKey: .plot) ??
        /// else for description
        container.decodeIfPresent(String.self, forKey: .description) ?? ""
        
        genre = try container.decodeIfPresent([String].self, forKey: .genre) ?? []
        
        playcount = try container.decodeIfPresent(Int.self, forKey: .playcount) ?? 0
        
        rating = try container.decodeIfPresent(Int.self, forKey: .userrating) ?? rating
        
        file = try container.decodeIfPresent(String.self, forKey: .file) ?? ""
        
        /// # Date and Time stuff
        
        year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        
        /// - Note: Episodes  have no 'premiered' date but an 'firstaired' date
        /// Check for Movies and TV shows first
        premiered = try container.decodeIfPresent(String.self, forKey: .premiered) ??
        /// else for Episodes
        container.decodeIfPresent(String.self, forKey: .firstAired) ?? ""

        dateAdded = try container.decodeIfPresent(String.self, forKey: .dateAdded) ?? ""

        lastPlayed = try container.decodeIfPresent(String.self, forKey: .lastPlayed) ?? ""
        
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? runtime

        /// # Art
        art = try container.decodeIfPresent([String: String].self, forKey: .art) ?? [:]

        /// # Video Stuff
        
        tagline = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
        
        movieSetTitle = try container.decodeIfPresent(String.self, forKey: .movieSetTitle) ?? ""

        cast = try container.decodeIfPresent([ActorItem].self, forKey: .cast) ?? []
        
        country = try container.decodeIfPresent([String].self, forKey: .country) ?? []
        
        streamDetails = try container.decodeIfPresent(StreamDetails.self, forKey: .streamDetails) ?? StreamDetails()
        
        /// # TV show stuff
        
        showtitle = try container.decodeIfPresent(String.self, forKey: .showtitle) ?? ""
        
        episode = try container.decodeIfPresent(Int.self, forKey: .episode) ?? 0
        
        season = try container.decodeIfPresent(Int.self, forKey: .season) ?? 0
        
        studio = try container.decodeIfPresent([String].self, forKey: .studio) ?? []
        
        /// # Audio stuff

        /// - Note: A JSON artist response can be a `String` or an `Array<String>`
        if let artist = try? container.decodeIfPresent(String.self, forKey: .artist) {
            /// The artist is a String, so most probably from AudioLibrary.GetArtists
            self.artists = [artist]
        }
        if let artists = try? container.decodeIfPresent([String].self, forKey: .artist) {
            self.artists = artists
        }
        
        /// Artist sort name
        sortname = try container.decodeIfPresent(String.self, forKey: .sortname) ?? ""
        /// Artist sort name for albums
        sortartist = try container.decodeIfPresent(String.self, forKey: .sortartist) ?? ""

        
        /// Artist genres
        artistGenres = try container.decodeIfPresent([ArtistGenre].self, forKey: .artistGenres) ?? []
        
        /// Album
        album = try container.decodeIfPresent(String.self, forKey: .album) ?? ""
        
        /// Track
        track = try container.decodeIfPresent(Int.self, forKey: .track) ?? 0
        
        /// Compilation (album item)
        compilation = try container.decodeIfPresent(Bool.self, forKey: .compilation) ?? compilation
        /// Compilation (artist item)
        compilation = !(try container.decodeIfPresent(Bool.self, forKey: .isAlbumArtist) ?? !compilation)
        
        /// Duration of an album
        runtime = try container.decodeIfPresent(Int.self, forKey: .albumDuration) ?? runtime
        
        /// Duration of a song
        runtime = try container.decodeIfPresent(Int.self, forKey: .duration) ?? runtime
        
        /// # ID of items

        movieID = try container.decodeIfPresent(Int.self, forKey: .movieID) ?? 0

        movieSetID = try container.decodeIfPresent(Int.self, forKey: .movieSetID) ?? 0

        tvshowID = try container.decodeIfPresent(Int.self, forKey: .tvshowID) ?? 0

        episodeID = try container.decodeIfPresent(Int.self, forKey: .episodeID) ?? 0

        musicVideoID = try container.decodeIfPresent(Int.self, forKey: .musicVideoID) ?? 0

        /// - Note: A JSON artistID response can be a `Int` or an `Array<Int>`
        if let artist = try? container.decodeIfPresent(Int.self, forKey: .artistID) {
            /// The artistID is a Int, so most probably from AudioLibrary.GetArtists
            self.artistID = artist
        }
        if let artists = try? container.decodeIfPresent([Int].self, forKey: .artistID) {
            /// The artistID is a {Int}, so most probably from AudioLibrary.GetAlbums or AudioLibrary.GetSongs
            self.artistIDs = artists
        }
        
        albumID = try container.decodeIfPresent(Int.self, forKey: .albumID) ?? 0
        
        songID = try container.decodeIfPresent(Int.self, forKey: .songID) ?? 0
    }
}

// MARK: Helper function

extension KodiResponse {
    
    /// Get a specific art item from the collection
    /// - Parameters:
    ///   - art: The art collection
    ///   - type: The kind of ard we want
    /// - Returns: An internal Kodi URL for the art
    func getSpecificArt(art: [String: String], type: ArtType) -> String {
        switch type {
        case .poster:
            if let posterArt = art["poster"] {
                return getFilePath(file: posterArt, type: .art)
            }
            if let posterArt = art["season.poster"] {
                return getFilePath(file: posterArt, type: .art)
            }
            if let posterArt = art["thumbnail"] {
                return getFilePath(file: posterArt, type: .art)
            }
            if let posterArt = art["thumb"] {
                return getFilePath(file: posterArt, type: .art)
            }
        case .fanart:
            if let fanartArt = art["fanart"] {
                return getFilePath(file: fanartArt, type: .art)
            }
            if let fanartArt = art["tvshow.fanart"] {
                return getFilePath(file: fanartArt, type: .art)
            }
            if let posterArt = art["thumbnail"] {
                return getFilePath(file: posterArt, type: .art)
            }
            if let posterArt = art["icon"] {
                return getFilePath(file: posterArt, type: .art)
            }
            /// Fallback to poster
            return getSpecificArt(art: art, type: .poster)
        case .thumbnail:
            if let posterArt = art["thumbnail"] {
                return getFilePath(file: posterArt, type: .art)
            }
            if let posterArt = art["thumb"] {
                return getFilePath(file: posterArt, type: .art)
            }
            /// Kodi likes 'Icon' for a music video thumb
            if let posterArt = art["icon"] {
                return getFilePath(file: posterArt, type: .art)
            }
        }
        return ""
    }
}

// MARK: Sub Structs and Enums

extension KodiResponse {
    
    /// Song genres struct
    struct ArtistGenre: Codable, Identifiable, Hashable {
        /// Make it identifiable
        var id = UUID()
        /// The genre ID
        var genreID: Int = 0
        /// Title of the genre
        var title: String = ""
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            /// The keys
            case title
            /// lowerCamelCase
            case genreID = "genreid"
        }
    }
    
    enum ArtType {
        /// Poster
        /// - Note: Poster will fallback to thumbnail or thumb if needed
        case poster
        /// Fanart
        /// - Note: Fanart will fallback to poster if needed
        case fanart
        /// Thumbnail
        /// - Note: Thumnail will fallback to poster if needed
        case thumbnail
    }
}
