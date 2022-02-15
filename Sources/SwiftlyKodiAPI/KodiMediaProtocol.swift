//
//  KodiItem.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 04/02/2022.
//

import Foundation

/// A protocol for a media item in the Kodi Library
///
/// The following media items do confirm to this protocol:
///
/// - Movie
/// - TV show
/// - TV episide
/// - Music video
public protocol KodiMediaProtocol: Codable {
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
    /// The cast of the item
    var cast: [ActorItem] { get }
    /// premiered
    var premiered: String { get }
    /// Year of release
    var year: Int { get }
    /// Runtime of the item
    var runtime: Int { get }
    /// The art for the item
    var art: [String: String] { get }
    /// The internal Kodi file location of the item;
    /// use ``fileURL`` to get the full URL
    var file: String { get }
}

public extension KodiMediaProtocol {
    /// Make it indentifiable
    var id: UUID {
        return UUID()
    }
    /// The optional poster for the item
    var poster: String {
        if let posterArt = art["poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["season.poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["thumbnail"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        return ""
    }
    /// The optional fanart for the item
    var fanart: String? {
        if let posterArt = art["fanart"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["tvshow.fanart"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        return nil
    }
    /// The genres for the item
    /// - Note: TV show episodes have no genre; it will be calculated by season and episode number
    var genres: String {
        return genre.joined(separator: "・")
    }
    /// The full Kodi file location of the item
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
    /// Details
    var details: String {
        var details = genre
        details.append(releaseYear)
        return details.joined(separator: "・")
    }
    /// Duration
    var duration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief

        return formatter.string(from: TimeInterval(runtime))!    }
}
