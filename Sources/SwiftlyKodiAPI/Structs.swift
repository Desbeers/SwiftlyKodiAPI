//
//  Structs.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 10/02/2022.
//

import Foundation

/// The struct of a host item
public struct HostItem: Codable, Identifiable, Hashable {
    /// Give it an ID
    public var id: UUID
    /// Description of the host
    public var description: String
    /// IP of the host
    public var ip: String
    /// Port of the host
    public var port: String
    /// TCP of the host
    public var tcp: String
    /// Username of the host
    public var username: String
    /// Password of the host
    public var password: String
    public init(id: UUID = UUID(),
                description: String = "Kodi",
                ip: String = "192.168.11.200",
                port: String = "8080",
                tcp: String = "9090",
                username: String = "kodi",
                password: String = "kodi"
    ) {
        self.id = id
        self.description = description
        self.ip = ip
        self.port = port
        self.tcp = tcp
        self.username = username
        self.password = password
    }
}

public struct KodiMediaFilter: Hashable, Equatable {
    public var title: String?
    public var subtitle: String?
    public var setID: Int?
    public var setInfo: MovieSetItem?
    public var setMovies: [MovieItem]?
    public var genre: String?
    public var search: String?
    public var media: KodiMedia
    public init(title: String? = nil,
                subtitle: String? = nil,
                setID: Int? = nil,
                setInfo: MovieSetItem? = nil,
                setMovies: [MovieItem]? = nil,
                genre: String? = nil,
                search: String? = nil,
                media: KodiMedia = .movie
    ) {
        self.title = title
        self.subtitle = subtitle
        self.setID = setID
        self.setInfo = setInfo
        self.setMovies = setMovies
        self.genre = genre
        self.search = search
        self.media = media
    }
}


