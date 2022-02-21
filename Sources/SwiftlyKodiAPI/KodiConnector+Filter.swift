//
//  KodiConnector+Filter.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Filter the Kodi library for specific items
    /// - Parameter filter: A struct with al the filter parameters
    /// - Returns: All Kodi media items confirming to the filter
    public func filter(_ filter: KodiFilter) async -> [KodiItem] {
        /// Start with an empty array
        var items: [KodiItem] = []
        
        switch filter.media {
        case .movie:
            /// If `setID` is set it means we want movies from a specific set
            if let setID = filter.setID {
                items = library.filter { $0.media == .movie && $0.setID == setID }
                .sortByYearAndTitle()
            } else {
                items = library.filter { $0.media == .movie } .uniqueSet()
                    .sortBySetAndTitle()
            }
        case .tvshow:
            items = library.filter { $0.media == .tvshow}
        case .episode:
            items = library.filter { $0.media == .episode && $0.tvshowID == filter.tvshowID }
        case .musicvideo:
            /// If `artist` is set we filter music videos for this specific artist
            if let artist = filter.artist {
                items = library
                    .filter { $0.media == .musicvideo }
                    .filter { $0.artist.contains(artist.first ?? "") }
                    .sorted { $0.releaseDate < $1.releaseDate }
            } else {
                /// Filter for one music video for earch artist to build an Artist View
                items = library.filter { $0.media == .musicvideo } .unique { $0.artist }
            }
        case .all:
            items = library
        default:
            items = [KodiItem]()
        }
        /// Now that filtering on media type is done, check if some additional fitereing is needed
        if let genre = filter.genre {
            items = items
                .filter { $0.genre.contains(genre) }
                .sortBySetAndTitle()
//            if filter.setID == nil {
//                items = items.uniqueSet()
//            }
        }
        /// That should be it!
        return items
    }
    
}

/// The struct for a Kodi filter that can be send to the ``KodiConnector/filter(_:)`` function to filter the library
public struct KodiFilter {
    /// Public init is needed because this struct is in a package so doesn't give it 'for free'...
    public init(media: KodiMedia, title: String? = nil, subtitle: String? = nil, fanart: String? = nil, tvshowID: Int? = nil, setID: Int? = nil, artist: [String]? = nil, genre: String? = nil, search: String? = nil) {
        self.media = media
        self.title = title
        self.subtitle = subtitle
        self.fanart = fanart
        self.tvshowID = tvshowID
        self.setID = setID
        self.artist = artist
        self.genre = genre
        self.search = search
    }
    /// The type of media
    public var media: KodiMedia
    /// The title that can be used in a View
    public var title: String?
    /// The subtitle that can be used in a View
    public var subtitle: String?
    /// The fanart that can be used in a View
    public var fanart: String?
    /// The TV show ID when filtering for episodes
    public var tvshowID: Int?
    /// The Movie Set ID when filtering for a movie set
    public var setID: Int?
    /// The artist when filtering for a specific artist
    public var artist: [String]?
    /// The genre when filtering for a specific genre
    public var genre: String?
    /// The search string
    public var search: String?

}
