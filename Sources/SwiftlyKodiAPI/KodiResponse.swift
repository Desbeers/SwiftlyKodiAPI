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
/// The result will be added to ``MediaItem``'s in their respectifly callers.
///
/// This `Struct` will not take care of that because tha will be messy,
/// the list is already long enough...
struct KodiResponse: Codable {

    /// # General stuff
    
    /// Title of the item
    var title: String = ""
    
    /// The description of the item
    /// - Note: This can be a 'real' description or a plot; both will be stored as 'description`
    var description: String = ""
    
    /// The playcount of the item
    var playcount: Int = 0
    
    /// # Date and Time stuff
    
    /// The full release date of the item
    /// - Note: An episode has no release date, but a first-aired date.
    ///         The JSON decoder takes care of the mapping
    var releaseDate: String {
        return premiered.isEmpty ? year.description + "-01-01" : premiered
    }
    
    /// The release year of the item
    public var releaseYear: String {
        let components = Calendar.current.dateComponents([.year], from: releaseDate.kodiDate())
        return components.year?.description ?? "0000"
    }
    
    /// The date the item was added to the Kodi database
    var dateAdded: String = ""
    
    /// Duration of the item in hours and minutes
    public var duration: String {
        return runtimeToDuration(runtime: runtime)
    }
    
    /// # Video stuff
    
    /// The cast of the item (movie and episode)
    var cast: [ActorItem] = []

    /// # Movie stuff

    /// The optional title of the movie set
    /// - Note: The function that loads movie items will fill this in
    var movieSetTitle: String = ""
    
    /// # TV show and Episode stuff
    
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
    var artist: [String] = []
    
    /// The name of an album (album or song item)
    var album: String = ""
    
    /// The track of an item  (music video, album or song item)
    var track: Int = 0
    
    /// # Art stuff
    
    /// The poster of the item
    var poster: String {
        return getSpecificArt(art: art, type: .poster)
    }
    
    /// The fanart for the item
    var fanart: String {
        return getSpecificArt(art: art, type: .fanart)
    }
    
    /// The full Kodi file location of the item
    public var filePath: String {
        return getFilePath(file: file, type: .file)
    }
    
    /// Default SF symbol for the item
    public var icon: String = "questionmark"
    
    /// # ID's of items

    /// The movie ID
    public var movieID: Int = 0
    
    /// The movie set ID
    public var movieSetID: Int = 0
    
    /// Optional set name (movie)
    public var setName: String = ""
    
    /// The TV show ID
    public var tvshowID: Int = 0
    
    /// The episode ID
    public var episodeID: Int = 0
    
    /// The music video ID
    public var musicvideoID: Int = 0
    
    /// The artist ID
    public var artistID: Int = 0
    
    /// # Internal variables
    
    /// Art of the item
    var art: [String: String] = [:]
    
    /// Location of the item
    var file: String = ""
    
    /// Plot of the item
    var plot: String = ""
    
    /// Genre for the item
    var genre: [String] = []
    
    /// Tagline of the item (movie)
    var tagline: String = ""
    
    /// Runtime of the item
    var runtime: Int = 0
    
    /// Studio of a TV show
    var studio: [String] = []
    
    /// Year of release of the item
    var year: Int = 0
    
    /// Premiered date of the item
    var premiered: String = ""
    
    /// First aired date of the item (episode)
    var firstaired: String = ""
    
    /// The sorttitle of the item; can be empty
    /// - Note: Kodi is using `sortname` for artists but that will be assigned to this one
    var sorttitle: String = ""

    /// The sortname of an artist; can be empty
    var sortname: String = ""
    
    /// # Sorting
    
    var sortBySetAndTitle: String {
        return setName.isEmpty ? sorttitle.isEmpty ? title : sorttitle : setName
    }
    var sortByTitle: String {
        sorttitle.isEmpty ? title : sorttitle
    }
}

// MARK: Coding keys

extension KodiResponse {
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        /// The public keys
        case title, description, playcount, episode, season, cast, artist
        /// Camel Case
        case setName = "set"
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
        case musicvideoID = "musicvideoid"
        /// Camel Case
        case artistID = "artistid"
        /// lowerCamelCase
        case dateAdded = "dateadded"
        /// # The internal keys
        /// Keys that are not exposed outside of the package
        case plot, tagline, genre, studio, showtitle, year, premiered, firstaired, art, runtime, sorttitle, sortname, file
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
        
        file = try container.decodeIfPresent(String.self, forKey: .file) ?? ""
        
        /// # Date and Time stuff
        
        year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        
        /// - Note: Episodes  have no 'premiered' date but an 'firstaired' date
        /// Check for Movies and TV shows first
        premiered = try container.decodeIfPresent(String.self, forKey: .premiered) ??
        /// else for Episodes
        container.decodeIfPresent(String.self, forKey: .firstaired) ?? ""

        dateAdded = try container.decodeIfPresent(String.self, forKey: .dateAdded) ?? ""

        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? 0

        /// # Art
        art = try container.decodeIfPresent([String: String].self, forKey: .art) ?? [:]

        /// # Video Stuff
        
        tagline = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
        
        setName = try container.decodeIfPresent(String.self, forKey: .setName) ?? ""

        cast = try container.decodeIfPresent([ActorItem].self, forKey: .cast) ?? []
        
        /// # TV show stuff
        
        showtitle = try container.decodeIfPresent(String.self, forKey: .showtitle) ?? ""
        
        episode = try container.decodeIfPresent(Int.self, forKey: .episode) ?? 0
        
        season = try container.decodeIfPresent(Int.self, forKey: .season) ?? 0
        
        studio = try container.decodeIfPresent([String].self, forKey: .studio) ?? []
        
        /// # Audio stuff

        /// - Note: A JSON artist response can be a String or an Array
        if let artist = try? container.decodeIfPresent(String.self, forKey: .artist) {
            /// The artist is a String, so most probably from AudioLibrary.GetArtists; use it as title
            self.title = artist
            self.artist = [artist]
        }
        if let artists = try? container.decodeIfPresent([String].self, forKey: .artist) {
            self.artist = artists
        }
        
        /// Artist sort name
        sortname = try container.decodeIfPresent(String.self, forKey: .sortname) ?? ""
        
        /// Album
        album = try container.decodeIfPresent(String.self, forKey: .album) ?? ""
        
        /// Track
        track = try container.decodeIfPresent(Int.self, forKey: .track) ?? 0
        
        /// # ID of items

        movieID = try container.decodeIfPresent(Int.self, forKey: .movieID) ?? 0

        movieSetID = try container.decodeIfPresent(Int.self, forKey: .movieSetID) ?? 0

        tvshowID = try container.decodeIfPresent(Int.self, forKey: .tvshowID) ?? 0

        episodeID = try container.decodeIfPresent(Int.self, forKey: .episodeID) ?? 0

        musicvideoID = try container.decodeIfPresent(Int.self, forKey: .musicvideoID) ?? 0

        artistID = try container.decodeIfPresent(Int.self, forKey: .artistID) ?? 0
    }
}

// MARK: Helper function

extension KodiResponse {

    /// Convert an internal Kodi path to a full path
    /// - Parameters:
    ///   - file: The internal Kodi path
    ///   - type: The type of remote file
    /// - Returns: A string with the full path to the file
    func getFilePath(file: String, type: FileType) -> String {
        let host = KodiConnector.shared.host
        /// Encoding
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: ":-._~") /// as per RFC 3986
        /// Image URL
        let kodiImageAddress = "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/\(type.rawValue)/"
        return kodiImageAddress + file.addingPercentEncoding(withAllowedCharacters: allowed)!
    }

    /// Convert runtime in seconds to a formatted time String
    /// - Parameter runtime: Time in minutes
    /// - Returns: The time as a formatted String
    func runtimeToDuration(runtime: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(runtime))!
    }
    
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
            // Fallback to poster
            return getSpecificArt(art: art, type: .poster)
        }
        return ""
    }
}

// MARK: Sub Structs and Enums

extension KodiResponse {
    
    /// A struct for an actor that is part of the cast in a movie or TV episode
    struct ActorItem: Codable, Identifiable, Hashable {
        /// Make it identifiable
        public var id = UUID()
        /// The name of the actor
        public var name: String = ""
        /// The order in the cast list
        public var order: Int = 0
        /// The role of the actor
        public var role: String = ""
        /// The optional thumbnail of the actor
        public var thumbnail: String? = ""
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            /// The keys for this Actor Item
            case name, order, role, thumbnail
        }
    }
    
    enum ArtType {
        /// Poster
        /// - Note: Poster will fallback to thumbnail or thumb if needed
        case poster
        /// Fanart
        /// - Note: Fanart will fallback to poster if needed
        case fanart
    }
    
    /// The types of Kodi remote files
    enum FileType: String {
        /// An image; poster, fanart etc...
        case art = "image"
        /// A file, either video or audio
        case file = "vfs"
    }
}
