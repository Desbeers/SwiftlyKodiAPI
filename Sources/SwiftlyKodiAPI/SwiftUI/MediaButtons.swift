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
                Task {
                    if let playerID = await kodi.getPlayerID() {
                        Player.playPause(playerID: playerID)
                    }
                }
            }, label: {
                Image(systemName: kodi.player.speed == 1 ? "pause.fill" : "play.fill")
            })
            .disabled(kodi.player.kind == .none)
        }
    }
    
    /// Toggle shuffle button
    struct SetShuffle: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = await kodi.getPlayerID() {
                        Player.setShuffle(playerID: playerID)
                    }
                }
            }, label: {
                Image(systemName: "shuffle")
            })
            .disabled(!kodi.player.canShuffle)
        }
    }
    
    /// Toggle repeat button
    struct SetRepeat: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = await kodi.getPlayerID() {
                        Player.setRepeat(playerID: playerID)
                    }
                }
            }, label: {
                Image(systemName: repeatingIcon)
            })
            .disabled(!kodi.player.canRepeat)
        }
        /// The icon to show for 'repeat'
        var repeatingIcon: String {
            /// Standard icon for 'repeat'
            var icon = "repeat"
            /// Overrule if needed
            if kodi.player.repeating == .one {
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
                    print("LAST PLAYED")
                    await AudioLibrary.getSongsTest(
                        sort: List.Sort(method: .lastPlayed, order: .descending),
                        limits: List.Limits(end: 10)
                    )
//                    await AudioLibrary.getSongsTest(
//                        filter: List.Filter(albumID: 3),
//                        sort: List.Sort(method: .title, order: .ascending),
//                        limits: List.Limits(end: 10)
//                    )
//                    await AudioLibrary.getSongsTest(filter: List.Filter(artistID: 10))
                }
            }, label: {
                Text("Debug")
            })
        }
    }
}

