//
//  Media+Artwork.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Media {
    
    /// Artwork for a Media item
    struct Artwork: Codable, Equatable {
        public var banner: String = ""
        public var fanart: String = ""
        public var poster: String = ""
        public var thumb: String = ""
        public var seasonPoster: String = ""
        
        enum CodingKeys: String, CodingKey {
            case banner
            case fanart
            case poster
            case thumb
            case seasonPoster = "season.poster"
        }
    }
}


public extension Media.Artwork {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Media.Artwork.CodingKeys> = try decoder.container(keyedBy: Media.Artwork.CodingKeys.self)
        self.banner = try container.decodeIfPresent(String.self, forKey: Media.Artwork.CodingKeys.banner) ?? ""
        self.fanart = try container.decodeIfPresent(String.self, forKey: Media.Artwork.CodingKeys.fanart) ?? ""
        self.poster = try container.decodeIfPresent(String.self, forKey: Media.Artwork.CodingKeys.poster) ?? ""
        self.thumb = try container.decodeIfPresent(String.self, forKey: Media.Artwork.CodingKeys.thumb) ?? ""
        self.seasonPoster = try container.decodeIfPresent(String.self, forKey: Media.Artwork.CodingKeys.seasonPoster) ?? ""
    }
    
}
