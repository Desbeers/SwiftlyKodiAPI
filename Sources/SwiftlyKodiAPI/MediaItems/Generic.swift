//
//  File.swift
//  
//
//  Created by Nick Berendsen on 16/02/2022.
//

import Foundation

extension GenericItem {
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        /// The public keys
        case title, subtitle, description, episode, season, cast, playcount
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
        /// # The internal keys
        /// Keys that are not exposed outside of the package
        case plot, tagline, genre, artist, showtitle, year, premiered, firstaired, art, runtime, sorttitle, file
    }
}

/// A struct that can be a movie, TV show, episode or Music Video
public struct GenericItem: KodiItem, Codable, Identifiable {

    /// Make it indentifiable
    public var id = UUID()
    
    /// The kind of media
    public var media: KodiMedia = .movie
    
    /// The title of the item
    /// - Movie: The movie title
    /// - TV show: The TV show title
    /// - Episode: The TV show title
    /// - Music Video: The artist name
    public var title: String = ""
    
    /// The subtitle of the item
    /// - Movie: The tagline
    /// - TV show: *Not in use*
    /// - Episode: The episode title
    /// - Music Video: The track name
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
    /// - Episode: Episode number + Premiered
    /// - Music Video: Genre + Year
    public var details: String {
        return genre.joined(separator: "・")
    }
    
    /// The playcount of the item
    public var playcount: Int = 0
    
    /// The cast of the item (movie and episode)
    public var cast: [ActorItem] = []
    
    /// # Episode stuff
    
    public var episode: Int = 0
    public var season: Int = 0
    
    /// # Calculated stuff
    
    /// The full release date of the item
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
    
    /// Duration of the item
    public var duration: String  {
        return runtimeToDuration(runtime: runtime)
    }
    
    /// The poster of the item
    public var poster: String {
        if let posterArt = art["poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["season.poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["thumbnail"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        return ""
    }
    
    /// The optional fanart for the item
    public var fanart: String? {
        if let posterArt = art["fanart"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["tvshow.fanart"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        return nil
    }
    
    /// The full Kodi file location of the item
    public var fileURL: URL {
        return URL(string: file.kodiFileUrl(media: .file))!
    }
    
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
    
    /// # Internal variables
    
    /// Art of the item
    public var art: [String: String] = [:]
    
    /// Location of the item
    public var file: String = ""
    
    /// Plot of the item
    var plot: String = ""
    
    /// Genre for the item
    public var genre: [String] = []
    
    /// Tagline of the item (movie)
    var tagline: String = ""
    
    /// Tagline of the item (music video)
    var artist: String = ""
    
    /// Runtime of the item
    public var runtime: Int = 0
    
    /// Title of a TV show (episode)
    var showtitle: String = ""
    
    /// Year of release of the item
    public var year: Int = 0
    
    /// Premiered date of the item
    public var premiered: String = ""
    
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

extension GenericItem {
    /// In an extension so we can still use the memberwise initializer.
    /// - Note: See https://sarunw.com/posts/how-to-preserve-memberwise-initializer/
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        sorttitle = try container.decodeIfPresent(String.self, forKey: .sorttitle) ?? ""

        /// # Subtitle is different for each media kind
        /// Movie subtitle
        subtitle = try container.decodeIfPresent(String.self, forKey: .tagline) ??
        /// Episode subtitle
        container.decodeIfPresent(String.self, forKey: .showtitle) ??
        /// Music Video subtitle
        container.decodeIfPresent([String].self, forKey: .artist)?.joined(separator: "・") ?? ""

        description = try container.decodeIfPresent(String.self, forKey: .plot) ?? ""
        genre = try container.decodeIfPresent([String].self, forKey: .genre) ?? []
        cast = try container.decodeIfPresent([ActorItem].self, forKey: .cast) ?? []
        playcount = try container.decodeIfPresent(Int.self, forKey: .playcount) ?? 0
        setName = try container.decodeIfPresent(String.self, forKey: .setName) ?? ""
        file = try container.decodeIfPresent(String.self, forKey: .file) ?? ""
        
        /// # Dates
        year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        /// Movies and TV shows
        premiered = try container.decodeIfPresent(String.self, forKey: .premiered) ??
        /// Episodes
        container.decodeIfPresent(String.self, forKey: .firstaired) ?? ""
        
        
        art = try container.decodeIfPresent([String: String].self, forKey: .art) ?? [:]
        
        /// # Episode stuff
        episode = try container.decodeIfPresent(Int.self, forKey: .episode) ?? 0
        season = try container.decodeIfPresent(Int.self, forKey: .season) ?? 0

        /// # ID of items
        movieID = try container.decodeIfPresent(Int.self, forKey: .movieID) ?? 0
        setID = try container.decodeIfPresent(Int.self, forKey: .setID) ?? 0
        tvshowID = try container.decodeIfPresent(Int.self, forKey: .tvshowID) ?? 0
        episodeID = try container.decodeIfPresent(Int.self, forKey: .episodeID) ?? 0
        musicvideoID = try container.decodeIfPresent(Int.self, forKey: .musicvideoID) ?? 0

        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? 0

    }
    
    func runtimeToDuration(runtime: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(runtime))!
    }
}
