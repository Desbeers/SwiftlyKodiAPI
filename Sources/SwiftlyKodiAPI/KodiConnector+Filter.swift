//
//  KodiConnector+Filter.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Filter the media library for specific items
    /// - Parameter filter: A struct with al the filter parameters
    /// - Returns: All Kodi media items confirming to the filter
    func filter(_ filter: MediaFilter) -> [MediaItem] {
        /// Get the library
        var items = media
        /// Remove Kodi items that we don't need
        if filter.media != .all {
            items.removeAll(where: { $0.media != filter.media } )
        }

        switch filter.media {
        case .movie:
            /// If `setID` is set it means we want movies from a specific set
            if let movieSetID = filter.movieSetID {
                items = items.filter { $0.movieSetID == movieSetID }
                items.sortByYearAndTitle()
            } else {
                /// Remove all movies tat belong to a set
                items = items.filter { $0.movieSetID == 0 }
                /// Add the sets
                items += media.filter { $0.media == .movieSet}
                //items = media.filter { $0.media == .movieSet}
                //items.uniqueSet()
                items.sortBySetAndTitle()
            }
        case .tvshow:
            break
        case .episode:
            items = items.filter { $0.tvshowID == filter.tvshowID }
            
            items = items.sorted { ($0.season == 0 ? Int.max : $0.season) < ($1.season == 0 ? Int.max : $1.season) }
            
        case .musicVideo:
            /// If `artist` is set we filter music videos for this specific artist
            if let artist = filter.artist {
                items = items
                    .filter { $0.artists.contains(artist.first ?? "") }
                    .sorted { $0.releaseDate < $1.releaseDate }
            }
            /// If `album` is set we filter music videos for this specific album
            /// - Note: A Music Video Album has no ID so we have to go by album name...
            if let album = filter.album {
                items = items
                    .filter { $0.album == album.album }
                    .sorted { $0.releaseDate < $1.releaseDate }
            } else {
                /// Reduce the list to one Music Video for each album
                items.uniqueMusicVideoAlbum()
                
            }

        case .musicVideoArtist:
            let artists = media
                .filter { $0.media == .musicVideo }
                .unique { $0.artists }
                .map { $0.artists}
            let musicVideos = media
                .filter { $0.media == .artist && artists.contains($0.artists)}
            //items = musicVideos.sorted { $0.sortByTitle < $1.sortByTitle}
            items = musicVideos.sorted { $0.releaseYear < $1.releaseYear}
        
        case .artist:
            items = items.filter { $0.compilation == filter.compilation }
        
        case .album:
            items = items.filter { $0.artists.contains(filter.artist?.first ?? "") }

        case .song:
            items = items.filter { $0.albumID == filter.album?.albumID }
        default:
            break
        }
        /// Now that filtering on media type is done, check if some additional filtering is needed
        if let genre = filter.genre {
            let media: [MediaType] = [.movie, .movieSet, .tvshow, .musicVideo]
            items = items.filter { media.contains($0.media) }
            items = items
                .filter { $0.genres.contains(genre) }
            if filter.movieSetID == nil {
                items.removeAll(where: { $0.media == .movie && $0.movieSetID != 0 } )
            }
            items.sortBySetAndTitle()
        }
        /// That should be it!
        return items
    }
    
}

/// The struct for a filter that can be apllied to a ``MediaItem`` array
public struct MediaFilter: Hashable, Equatable {
    /// Public init is needed because this struct is in a package so doesn't give it 'for free'...
    public init(media: MediaType,
                tvshowID: Int? = nil,
                movieSetID: Int? = nil,
                artist: [String]? = nil,
                album: MediaItem? = nil,
                genre: String? = nil,
                compilation: Bool = false,
                search: String? = nil
    ) {
        self.media = media
        self.tvshowID = tvshowID
        self.movieSetID = movieSetID
        self.artist = artist
        self.album = album
        self.genre = genre
        self.compilation = compilation
        self.search = search
    }
    /// The type of media
    public var media: MediaType
    /// The TV show ID when filtering for episodes
    public var tvshowID: Int?
    /// The Movie Set ID when filtering for a movie set
    public var movieSetID: Int?
    /// The artist when filtering for a specific artist
    public var artist: [String]?
    /// The album when filtering for a specific album
    public var album: MediaItem?
    /// The genre when filtering for a specific genre
    public var genre: String?
    /// Is the item part of a compilation or not
    public var compilation: Bool
    /// The search string
    public var search: String?

}
