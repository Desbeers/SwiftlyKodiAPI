//
//  KodiConnector+Task.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Debounce functions
struct Tasks {
    var getCurrentPlaylist = Debouncer(duration: 2)
    var setLibraryCache = Debouncer(duration: 10)
    var getPlayerState = Debouncer(duration: 2)
}
