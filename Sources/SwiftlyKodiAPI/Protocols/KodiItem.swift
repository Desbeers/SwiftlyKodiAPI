//
//  KodiItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// A ``KodiItem`` is any kind of item from the Kodi library (SwiftlyKodi Type)
///
/// It can be an artist, album, song, movie, movie set, tv show, epiode, music video or a genre
public protocol KodiItem: Codable, Identifiable, Equatable, Hashable {
    /// The ID of the item
    var id: Int { get }
    /// The kind of ``Library/Media``
    var media: Library.Media { get }
    /// The title of the item
    var title: String { get }
    /// The subtitle of the item
    var subtitle: String { get }
    /// The details of the item
    var details: String { get }
    /// The 'sort by title' of the item
    var sortByTitle: String { get }
    /// The playcount of the item
    var playcount: Int { get set }
    /// The last played date of the item
    var lastPlayed: String { get set }
    /// The user rating of the item
    var userRating: Int { get set }
    /// The poster of the item
    var poster: String { get }
    /// The fanart of the item
    var fanart: String { get }
    /// The location of the file
    var file: String { get }
    /// The search string
    var search: String { get }
}

extension KodiItem {
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
    public var playlistID: Int? {
        if let index = KodiPlayer.shared.currentPlaylist?.firstIndex(where: {$0.id == id}) {
            return index
        }
        return nil
    }
}
