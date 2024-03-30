//
//  AnyKodiItem.swift
//  Komodio
//
//  Created by Nick Berendsen on 14/08/2023.
//

import SwiftUI

/// A equatable struct that can hold any ``KodiItem``
public struct AnyKodiItem: Identifiable, Equatable, Hashable, Codable {
    public static func == (lhs: AnyKodiItem, rhs: AnyKodiItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.item.playcount == rhs.item.playcount &&
        lhs.item.lastPlayed == rhs.item.lastPlayed &&
        lhs.item.userRating == rhs.item.userRating
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public init(_ item: any KodiItem) {
        self.id = item.id
        self.item = item
    }

    public let id: String
    public let item: any KodiItem
    public var resume: Bool = false

    /// Coding keys
    enum CodingKeys: String, CodingKey {
        case id
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: AnyKodiItem.CodingKeys.self)
        
        try container.encode(self.id, forKey: AnyKodiItem.CodingKeys.id)
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.item = Audio.Details.Stream()
    }
}

extension Array where Element == any KodiItem {

    public func anykodiItem() -> [AnyKodiItem] {
        self.map { AnyKodiItem($0) }
    }
}

extension Array where Element: KodiItem {

    public func anykodiItem() -> [AnyKodiItem] {
        self.map { AnyKodiItem($0) }
    }
}
