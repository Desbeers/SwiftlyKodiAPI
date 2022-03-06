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
    func filter(_ filter: KodiFilter) -> [MediaItem] {
        /// Get the library
        var items = media
        /// Remove Kodi items that we don't need
        if filter.media != .all {
            items.removeAll(where: { $0.media != filter.media } )
        }

        switch filter.media {
        case .movie:
            /// If `setID` is set it means we want movies from a specific set
            if let setID = filter.setID {
                items = items.filter { $0.movieSetID == setID }
                items.sortByYearAndTitle()
            } else {
                items.uniqueSet()
                items.sortBySetAndTitle()
            }
        case .tvshow:
            break
        case .episode:
            items = items.filter { $0.tvshowID == filter.tvshowID }
        case .musicvideo:
            /// If `artist` is set we filter music videos for this specific artist
            if let artist = filter.artist {
                items = items
                    .filter { $0.artists.contains(artist.first ?? "") }
                    .sorted { $0.releaseDate < $1.releaseDate }
            }
            /// If `album` is set we filter music videos for this specific album
            if let album = filter.album {
                items = items
                    .filter { $0.album == album}
                    .sorted { $0.releaseDate < $1.releaseDate }
            } else {
                /// Reduce the list to one Music Video for each album
                items.uniqueMusicVideoAlbum()
                
            }

        case .musicVideoArtist:
            let artists = media
                .filter { $0.media == .musicvideo }
                .unique { $0.artists }
                .map { $0.artists}
            let musicVideos = media
                .filter { $0.media == .artist && artists.contains($0.artists)}
            items = musicVideos.sorted { $0.sortByTitle < $1.sortByTitle}
        default:
            break
        }
        /// Now that filtering on media type is done, check if some additional fitereing is needed
        if let genre = filter.genre {
            items = items
                .filter { $0.genres.contains(genre) }
            items.sortBySetAndTitle()
            if filter.setID == nil {
                items.uniqueSet()
            }
        }
        /// That should be it!
        return items
    }
    
}

/// The struct for a Kodi filter that can be send to the ``KodiConnector/filter(_:)`` function to filter the library
public struct KodiFilter: Hashable, Equatable {
    /// Public init is needed because this struct is in a package so doesn't give it 'for free'...
    public init(media: KodiMedia, title: String? = nil, subtitle: String? = nil, fanart: String? = nil, tvshowID: Int? = nil, setID: Int? = nil, artist: [String]? = nil, album: String? = nil, genre: String? = nil, search: String? = nil) {
        self.media = media
        self.title = title
        self.subtitle = subtitle
        self.fanart = fanart
        self.tvshowID = tvshowID
        self.setID = setID
        self.artist = artist
        self.album = album
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
    /// The album when filtering for a specific album
    public var album: String?
    /// The genre when filtering for a specific genre
    public var genre: String?
    /// The search string
    public var search: String?

}
