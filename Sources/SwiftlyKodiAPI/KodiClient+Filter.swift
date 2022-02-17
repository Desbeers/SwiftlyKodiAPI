//
//  File.swift
//  
//
//  Created by Nick Berendsen on 17/02/2022.
//

import Foundation

extension KodiClient {
    
    public func filter(_ filter: KodiFilter) async -> [GenericItem] {
        
        var items: [GenericItem] = []
        
        switch filter.media {
        case .movie:
            /// Movies in a set
            if let setID = filter.setID {
                items = library
                    .filter { $0.media == .movie && $0.setID == setID }
                    .sortByYearAndTitle()
            } else {
                items = library
                    .filter { $0.media == .movie }
                    .uniqueSet()
                    .sortBySetAndTitle()
            }
        case .tvshow:
            items = library
                .filter { $0.media == .tvshow}
        case .episode:
            items = library
                .filter { $0.media == .episode && $0.tvshowID == filter.tvshowID }
        case .musicvideo:
            if let artist = filter.artist {
                /// Because of being a 'general' struct; the artist of a music video is the 'subtitle'
                items = library
                    .filter { $0.media == .musicvideo }
                    .filter { $0.subtitle == artist }
                    .sorted { $0.releaseDate < $1.releaseDate }
            } else {
                items = library.filter { $0.media == .musicvideo } .unique { $0.subtitle }
            }
        case .all:
            items = library
        default:
            items = [GenericItem]()
        }
        if let genre = filter.genre {
            items = items
                .filter { $0.genre.contains(genre) }
                .uniqueSet()
        }
        return items
    }
    
}

public struct KodiFilter {
    public init(media: KodiMedia, title: String? = nil, subtitle: String? = nil, tvshowID: Int? = nil, setID: Int? = nil, artist: String? = nil, genre: String? = nil, search: String? = nil) {
        self.media = media
        self.title = title
        self.subtitle = subtitle
        self.tvshowID = tvshowID
        self.setID = setID
        self.artist = artist
        self.genre = genre
        self.search = search
    }
    public var media: KodiMedia
    public var title: String?
    public var subtitle: String?
    public var tvshowID: Int?
    public var setID: Int?
    public var artist: String?
    public var genre: String?
    public var search: String?

}
