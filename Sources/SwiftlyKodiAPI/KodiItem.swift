//
//  KodiItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// A struct for a Kodi Library Item
///
/// This can be one of the following:
/// - Movie
/// - TV show
/// - Episode
/// - Music video
public struct KodiItem: Codable, Identifiable, Equatable {
    public static func == (lhs: KodiItem, rhs: KodiItem) -> Bool {
        return lhs.playcount == rhs.playcount
    }
    
    /// Make it indentifiable
    public var id = UUID()
    
    /// The kind of media
    public var media: KodiMedia = .movie
    
    /// # General stuff
    
    /// The title of the item
    /// - Movie: The movie title
    /// - TV show: The TV show title
    /// - Episode: The name of the TV show
    /// - Music Video: The artist name
    public var title: String = ""
    
    /// The subtitle of the item
    /// - Movie: The tagline
    /// - TV show: *Not in use*
    /// - Episode: The name of the TV show
    /// - Music Video: The name of the track
    public var subtitle: String = ""
    
    /// The description of the item
    /// - Movie: The plot
    /// - TV show: The plot
    /// - Episode: The plot
    /// - Music Video: The plot
    public var description: String = ""
    
    /// The details of the item
    /// - Movie: Genre + Year
    /// - TV show: Genre + Year
    /// - Episode: Episode number + Season number
    /// - Music Video: Genre + Year
    public var details: String {
        var details: [String] = []
        /// Check if it is an episode
        if episode != 0 {
            details.append("Episode \(episode)")
            details.append("Season \(season)")
        } else {
            details = genre
            details.append(releaseYear)
        }
        return details.joined(separator: "・")
    }
    
    /// The genres of the item, as a combined String
    public var genres: String {
        return genre.joined(separator: "・")
    }
    
    /// # Date and Time stuff
    
    /// The full release date of the item
    /// - Note: An episode has no release date, but a first-ared date.
    ///         The JSON decoder takes care of the mapping
    public var releaseDate: Date {
        let date = premiered.isEmpty ? year.description + "-01-01" : premiered
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date) ?? Date()
    }
    /// The release year of the item
    public var releaseYear: String {
        let components = Calendar.current.dateComponents([.year], from: releaseDate)
        return components.year?.description ?? "0000"
    }
    
    /// The date the item was added to the Kodi database
    public var dateAdded: String = ""
    
    /// Duration of the item; presented as a formatted String
    public var duration: String {
        return runtimeToDuration(runtime: runtime)
    }
    
    /// The playcount of the item
    public var playcount: Int = 0
    
    /// # Video stuff
    
    /// The cast of the item (movie and episode)
    public var cast: [ActorItem] = []

    /// # Movie stuff

    /// The set info of the movie
    /// - Note: Will be filled in later
    public var setInfo = MovieSetItem()
    
    /// # TV show and Episode stuff
    
    /// The episode number of the TV show
    public var episode: Int = 0
    
    /// The season of the TV show
    public var season: Int = 0
    
    /// # Audio stuff
    
    /// Artist of the item (artist or music video)
    /// - Note: JSON can give a String or an Array; the decoder takes care of that
    ///         and we just keep it as Array because that is the most common
    public var artist: [String] = []
    
    /// # Art stuff
    
    /// The poster of the item
    public var poster: String {
        return getSpecificArt(art: art, type: .poster)
    }
    
    /// The fanart for the item
    public var fanart: String {
        return getSpecificArt(art: art, type: .fanart)
    }
    
    /// The full Kodi file location of the item
    public var fileURL: URL {
        return URL(string: file.kodiFileUrl(media: .file))!
    }
    
    /// Default SF symbol for the item
    public var icon: String = "questionmark"
    
    /// # ID's of items

    /// The movie ID
    public var movieID: Int = 0
    
    /// The set ID
    public var setID: Int = 0
    
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
    
    /// Title of a TV show (episode)
    var showtitle: String = ""
    
    /// Year of release of the item
    var year: Int = 0
    
    /// Premiered date of the item
    var premiered: String = ""
    
    /// First aired date of the item (episode)
    var firstaired: String = ""
    
    /// The sorttitle of the item; can be empty
    var sorttitle: String = ""
    
    /// # Sorting
    
    var sortBySetAndTitle: String {
        return setName.isEmpty ? sorttitle.isEmpty ? title : sorttitle : setName
    }
    var sortByTitle: String {
        sorttitle.isEmpty ? title : sorttitle
    }
}

extension KodiItem {
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        /// The public keys
        case title, subtitle, description, episode, season, cast, playcount, setInfo
        /// Camel Case
        case setName = "set"
        /// # The public ID's
        /// Camel Case
        case movieID = "movieid"
        /// Camel Case
        case setID = "setid"
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
        case plot, tagline, genre, artist, showtitle, year, premiered, firstaired, art, runtime, sorttitle, file
    }
}

extension KodiItem {
    /// In an extension so we can still use the memberwise initializer.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        /// # General stuff
        
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        
        sorttitle = try container.decodeIfPresent(String.self, forKey: .sorttitle) ?? ""
        
        /// - Note: Subtitle is different for each media kind
        /// Movie subtitle is the tagline, if any..
        subtitle = try container.decodeIfPresent(String.self, forKey: .tagline) ??
        /// else the show title for an Episode
        container.decodeIfPresent(String.self, forKey: .showtitle) ?? ""
        
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
        
        setName = try container.decodeIfPresent(String.self, forKey: .setName) ?? ""

        cast = try container.decodeIfPresent([ActorItem].self, forKey: .cast) ?? []
        
        /// # Episode stuff
        
        episode = try container.decodeIfPresent(Int.self, forKey: .episode) ?? 0
        
        season = try container.decodeIfPresent(Int.self, forKey: .season) ?? 0
        
        /// # Audio stuff

        /// - Note: A JSON artist response can be a String or an Array
        if let artist = try? container.decodeIfPresent(String.self, forKey: .artist) {
            /// The artist is a String, so most probably from AudioLibrary.GetArtists; use it as title
            self.title = artist
            self.subtitle = ""
            self.artist = [artist]
        }
        if let artists = try? container.decodeIfPresent([String].self, forKey: .artist) {
            /// The artist is an Array; use it as subtitle
            self.subtitle = artists.joined(separator: "・")
            self.artist = artists
        }

        /// # ID of items

        movieID = try container.decodeIfPresent(Int.self, forKey: .movieID) ?? 0

        setID = try container.decodeIfPresent(Int.self, forKey: .setID) ?? 0

        tvshowID = try container.decodeIfPresent(Int.self, forKey: .tvshowID) ?? 0

        episodeID = try container.decodeIfPresent(Int.self, forKey: .episodeID) ?? 0

        musicvideoID = try container.decodeIfPresent(Int.self, forKey: .musicvideoID) ?? 0

        artistID = try container.decodeIfPresent(Int.self, forKey: .artistID) ?? 0
    }
}

extension KodiItem {

    /// Conver runtime in seconds to a formatted time String
    /// - Parameter runtime: Time in minutes
    /// - Returns: The time as a formatted String
    func runtimeToDuration(runtime: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(runtime))!
    }
}

extension KodiItem {
    
    /// A struct for an actor that is part of the cast in a movie or TV episode
    public struct ActorItem: Codable, Identifiable, Hashable {
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
}

extension KodiItem {
    
    /// A struct for information about a Movie Set
    public struct MovieSetItem: Codable {
        /// The ID of the movie set
        public var setID: Int = 0
        /// The title of the movie set
        public var title: String = ""
        /// The playcount of the movie set
        public var playcount: Int = 0
        /// The art of the movie set
        public var art: [String: String] = [:]
        /// The description of the movie set
        public var description: String = ""
        /// The coding keys
        enum CodingKeys: String, CodingKey {
            case title, playcount, art
            /// Description is plot
            case description = "plot"
            /// Camel Case
            case setID = "setid"
        }
        /// The poster of the movie set
        public var poster: String {
            if let posterArt = art["poster"] {
                return posterArt.kodiFileUrl(media: .art)
            }
            return ""
        }
        /// The movie titles in the set
        public var movies: String = ""
        /// The count of movies in the set
        public var count: Int = 0
        /// The genres of the movies in the set
        public var genres: String = ""
    }
}
