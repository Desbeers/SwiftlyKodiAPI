//
//  MarkAsPlayed.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension MediaItem {
    
    /// Mark a ``MediaItem`` as played
    ///
    /// In Kodi, an item is marked as played if the playcount is greater than zero.
    ///
    /// This mutating function will add one to the total playcount and update the Kodi database.
    mutating public func markAsPlayed() {
        self.playcount += 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.lastPlayed = dateFormatter.string(from: Date())
        KodiConnector.shared.setMediaItemDetails(item: self)
    }
}
