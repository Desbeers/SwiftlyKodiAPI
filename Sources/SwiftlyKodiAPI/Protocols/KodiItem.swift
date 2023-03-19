//
//  KodiItem.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

/// A ``KodiItem`` is any kind of item from the Kodi library (SwiftlyKodi Type)
///
/// It can be an artist, album, song, movie, movie set, tv show, epiode, music video or a genre
public protocol KodiItem: Codable, Identifiable, Equatable, Hashable {
    /// The ID of the item
    var id: String { get }
    /// The Kodi ID of the item
    var kodiID: Library.id { get }
    /// The kind of ``Library/Media``
    var media: Library.Media { get }
    /// The title of the item
    var title: String { get }
    /// The subtitle of the item
    var subtitle: String { get }
    /// The details of the item
    var details: String { get }
    /// The description of the item (often plot)
    var description: String { get }
    /// The 'sort by title' of the item
    var sortByTitle: String { get }
    /// The playcount of the item
    var playcount: Int { get set }
    /// The date the item is added
    var dateAdded: String { get set }
    /// The release year of the item
    var year: Int { get set }
    /// The last played date of the item
    var lastPlayed: String { get set }
    /// The rating of the item
    var rating: Double { get set }
    /// The user rating of the item
    var userRating: Int { get set }
    /// The poster of the item
    var poster: String { get }
    /// The fanart of the item
    var fanart: String { get }
    /// The location of the file
    var file: String { get }
    /// The duration of the item
    var duration: Int { get }
    /// The resume position of the item
    var resume: Video.Resume { get set }
    /// The search string
    var search: String { get }
}

extension KodiItem {

    /// The ``Player/ID`` of the player
    var playerID: Player.ID {
        switch self.media {
        case .song, .stream:
            return .audio
        default:
            return .video
        }
    }
}

extension KodiItem {

    /// The ID of the playlist
    public var playlistID: Int? {
        if let index = KodiPlayer.shared.currentPlaylist?.firstIndex(where: { $0.id == id }) {
            return index
        }
        return nil
    }
}
