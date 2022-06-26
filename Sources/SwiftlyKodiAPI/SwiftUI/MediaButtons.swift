//
//  MediaButtons.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI media buttons
public struct MediaButtons {
    /// Just a placeholder
}

public extension MediaButtons {
    
    /// Play/Pause button
    struct PlayPause: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Player.playPause()
            }, label: {
                Image(systemName: kodi.playerProperties.speed == 1 ? "pause" : "play")
            })
        }
    }
}

