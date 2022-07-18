//
//  MediaButtons.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI media buttons
///
/// - Note: They are smart and will be disabled when not available
public enum MediaButtons {
    /// Just a placeholder
}

public extension MediaButtons {
    
    /// Play/Pause an item in the playlist
    ///
    /// There are a few senario's:
    /// - Playlist is empty: disable this button; there is nothing to play
    /// - Player is paused: do method .playerPlayPause to pause
    /// - Player is playing: do method .playerPlayPause to play
    /// - Player is stopped: do method .playerOpen to start the playlist
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
                Label("Play", systemImage: kodi.player.speed == 1 ? "pause.fill" : "play.fill")
            })
            .disabled(kodi.queue == nil)
            .help(kodi.player.speed == 1 ? "Pause your playlist" : kodi.player.playlistPosition == -1 ? "Start your playlist" : "Continue playing your playlist")
        }
    }

    /// Play the previous item
    ///
    /// - Note: Kodi is a bit weird; going to 'previous' goes to the beginning of an item when it played for a while; else it reallly goes to the previous item
    struct PlayPrevious: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = await kodi.getPlayerID() {
                        await Player.goTo(playerID: playerID, action: .previous)
                    }
                }
            }, label: {
                Label("Previous", systemImage: "backward.fill")
            })
            .disabled(kodi.player.playlistPosition == -1)
            /// You can't go back an item when in party mode
            .disabled(kodi.player.partymode)
        }
    }
    
    /// Play the next item
    struct PlayNext: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            
            Button(action: {
                Task {
                    if let playerID = await kodi.getPlayerID() {
                        await Player.goTo(playerID: playerID, action: .next)
                    }
                }
            }, label: {
                Label("Next", systemImage: "forward.fill")
            })
            /// Disable when playing the last item
            .disabled((kodi.player.playlistPosition) + 1 == kodi.queue?.count)
            /// Disable when not playing
            .disabled(kodi.player.playlistPosition == -1)
        }
    }
    
    /// Partymode button
    struct SetPartyMode: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Task {
                    Player.setPartyMode()
                }
            }, label: {
                Label("Party Mode", systemImage: "wand.and.stars.inverse")
                    .foregroundColor(kodi.player.partymode ? .white : .none)
            })
            .background(RoundedRectangle(cornerRadius: 4)
                .fill(kodi.player.partymode  ? Color.red : Color.clear))
            .help("Party mode")
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
                Label("Shuffle", systemImage: "shuffle")
                    .foregroundColor(kodi.player.shuffled ? .white : .none)
            })
            
            .background(RoundedRectangle(cornerRadius: 4)
            .fill(kodi.player.shuffled ? Color.accentColor : Color.clear))
            .disabled(kodi.player.partymode)
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
                Label("Repeat", systemImage: repeatingIcon)
                    .foregroundColor(kodi.player.repeating == .off ? .none : .white)
            })
            .background(RoundedRectangle(cornerRadius: 4)
            .fill(kodi.player.repeating  == .off ? .clear : .accentColor))
            .disabled(kodi.player.partymode)
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
    
    #if !os(tvOS)
    /// Volume slider
    struct VolumeSlider: View  {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        //@State private var volume: Double = 0
        public var body: some View {
            Label {
                Text("Volume")
            } icon: {
                HStack {
                    Button(
                        action: {
                            Task {
                                await Application.setMute()
                            }
                        },
                        label: {
                            Image(systemName: kodi.properties.muted ? "speaker.slash.fill" : "speaker.fill")
                                .foregroundColor(kodi.properties.muted ? .red : .primary)
                        }
                    )
                    .font(.caption)
                    /// - Note: Using 'onEditingChanged' because that will only be trickered when using the slider
                    ///         and not when programmaticly changing its value after a notification.
                    Slider(value: $kodi.properties.volume, in: 0...100,
                           onEditingChanged: { _ in
                        logger("Volume changed: \(kodi.properties.volume)")
                        Task {
                            await Application.setVolume(volume: kodi.properties.volume)
                        }
                    })
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.caption)
                }
            }
            .frame(width: 160)
        }
    }
    #endif
    
    /// Debug button
    struct Debug: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Task {
                    await Player.getItem(playerID: .audio)
                }
            }, label: {
                Text("Debug")
            })
        }
    }
}

