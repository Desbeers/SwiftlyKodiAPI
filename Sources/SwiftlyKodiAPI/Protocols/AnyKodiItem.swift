//
//  AnyKodiItem.swift
//  Komodio
//
//  Created by Nick Berendsen on 14/08/2023.
//

import SwiftUI

public struct AnyKodiItem: Identifiable, Equatable {
    public static func == (lhs: AnyKodiItem, rhs: AnyKodiItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.item.playcount == rhs.item.playcount &&
        lhs.item.lastPlayed == rhs.item.lastPlayed &&
        lhs.item.userRating == rhs.item.userRating
    }

    public init(_ item: any KodiItem) {
        self.id = item.id
        self.item = item
    }

    public let id: String
    public let item: any KodiItem
}

extension Array where Element == any KodiItem {

    public func anykodiItem() -> [AnyKodiItem] {
        return self.map { AnyKodiItem($0) }
    }
}

extension Array where Element: KodiItem {

    public func anykodiItem() -> [AnyKodiItem] {
        return self.map { AnyKodiItem($0) }
    }
}
