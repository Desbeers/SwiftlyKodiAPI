//
//  KodiConnector+Task.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Debounce functions
struct Tasks {
    var getCurrentPlaylist = Limiter(policy: .debounce, duration: 5)
    var setLibraryCache = Limiter(policy: .debounce, duration: 5)
    var getPlayerState = Limiter(policy: .debounce, duration: 2)
}
