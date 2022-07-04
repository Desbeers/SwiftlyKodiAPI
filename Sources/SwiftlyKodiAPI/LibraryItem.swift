//
//  LibraryItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public protocol LibraryItem: Codable, Identifiable, Equatable {
    /// The ID of the item
    var id: Int { get }
    /// The kind of ``Library/MediaType``
    var media: Library.Media { get }
}

public extension LibraryItem {
    func markAsPlayed() {
        print(self.media)
        print(self.id)
    }
}
