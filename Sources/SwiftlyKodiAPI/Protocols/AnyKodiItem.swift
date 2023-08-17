//
//  AnyKodiItem.swift
//  Komodio
//
//  Created by Nick Berendsen on 14/08/2023.
//

import SwiftUI

public struct AnyKodiItem: Identifiable {
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
