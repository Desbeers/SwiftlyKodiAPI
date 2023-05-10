//
//  Media+Artwork.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Media {

    /// Artwork for a Media item (Global Kodi Type)
    struct Artwork: Codable, Equatable, Hashable, Sendable {

        /// # Public init

        public init() {}

        /// # Media.Artwork

        public var banner: String = ""
        public var fanart: String = ""
        /// The poster of the item
        public var poster: String = ""
        public var thumb: String = ""
        public var icon: String = ""
        /// Song art: the poster of the album
        public var albumThumb: String = ""
        /// Episode art: the poster of the season
        public var seasonPoster: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case banner
            case fanart
            case poster
            case thumb
            case icon
            case albumThumb = "album.thumb"
            case seasonPoster = "season.poster"
        }
    }
}

public extension Media.Artwork {

    /// Custom decoder
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.banner = try container.decodeIfPresent(String.self, forKey: .banner) ?? ""
        self.fanart = try container.decodeIfPresent(String.self, forKey: .fanart) ?? ""
        self.poster = try container.decodeIfPresent(String.self, forKey: .poster) ?? ""
        self.thumb = try container.decodeIfPresent(String.self, forKey: .thumb) ?? ""
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? ""
        self.albumThumb = try container.decodeIfPresent(String.self, forKey: .albumThumb) ?? ""
        self.seasonPoster = try container.decodeIfPresent(String.self, forKey: .seasonPoster) ?? ""
    }
}
