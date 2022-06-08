//
//  TogglePlayedState.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension MediaItem {
    
    /// Toggle the played status of a ``MediaItem``.
    mutating public func togglePlayedState() {
        logger("Toggle play state")
        self.playcount = self.playcount == 0 ? 1 : 0
        /// Set or reset the last played date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.lastPlayed = self.playcount == 0 ? "" : dateFormatter.string(from: Date())
        KodiConnector.shared.setMediaItemDetails(item: self)
    }
}
