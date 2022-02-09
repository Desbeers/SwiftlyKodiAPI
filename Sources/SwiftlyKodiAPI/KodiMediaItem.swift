//
//  KodiItem.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 04/02/2022.
//

import Foundation

/// A protocol to define a media item in the Kodi Library:
/// - Movie
/// - TV show
/// - TV episide
/// - Music video
public protocol KodiMediaItem: Codable {
    /// The ID of the item
    var id: UUID { get }
    /// The title of the item
    var title: String { get }
    /// The subtitle of the item, optional
    var subtitle: String? { get }
    /// The genres of the item, an array
    var genre: [String] { get }
    /// The decription of the item
    var description: String { get }
    /// premiered
    var premiered: String { get }
    /// Year of release
    var year: Int { get }
    /// The art for the item
    var art: [String: String] { get }
    /// The internal Kodi location of the item
    var file: String { get }
}

public extension KodiMediaItem {
    /// The optional poster for the item
    var poster: String {
        if let posterArt = art["poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["season.poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        return ""
    }
    /// The optional fanart for the item
    var fanart: String? {
        if let posterArt = art["fanart"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        return nil
    }
    /// The genres for the item
    /// - Note: TV show episodes have no genre; it will be calculated by season and episode number
    var genres: String {
        return genre.joined(separator: "・")
    }
    /// The full URL to a Kodi vidieo item
    var fileURL: URL {
        return URL(string: file.kodiFileUrl(media: .file))!
    }
    /// The full release data as Date
    var releaseDate: Date {
        let date = premiered.isEmpty ? year.description + "-01-01" : premiered
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date) ?? Date()
    }
    /// The release year as String
    var releaseYear: String {
        let components = Calendar.current.dateComponents([.year], from: releaseDate)
        return components.year?.description ?? "0000"
    }
}
