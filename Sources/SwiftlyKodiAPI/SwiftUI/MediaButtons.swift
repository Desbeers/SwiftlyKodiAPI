//
//  MediaButtons.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI media buttons
public enum MediaButtons {
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
                //Text(kodi.playerProperties.activePlayer)
                Image(systemName: kodi.playerProperties.speed == 1 ? "pause.fill" : "play.fill")
            })
        }
    }
    
    /// Toggle shuffle button
    struct SetShuffle: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Player.setShuffle()
            }, label: {
                Image(systemName: "shuffle")
            })
        }
    }
    
    /// Toggle repeat button
    struct SetRepeat: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Player.setRepeat()
            }, label: {
                Image(systemName: repeatingIcon)
            })
        }
        /// The icon to show for 'repeat'
        var repeatingIcon: String {
            /// Standard icon for 'repeat'
            var icon = "repeat"
            /// Overrule if needed
            if kodi.playerProperties.repeating == .one {
                icon = "repeat.1"
            }
            return icon
        }
    }
    
    /// Debug button
    struct Debug: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Task {
                    await Player.getActivePlayers()
                }
            }, label: {
                Text("Debug")
            })
        }
    }
}

