//
//  MediaButtons.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// MARK: Media Buttons

/// Collection of SwiftUI media buttons (SwiftlyKodi Type)
///
/// The Views require to have the ``KodiPlayer`` Observable Class in the 'environment' or else your Application will crash
///
/// - Note: The buttons are smart and will be disabled when not applicable
public enum MediaButtons {
    // Just a namespace
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
        /// The KodiPlayer model
        @EnvironmentObject var player: KodiPlayer
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = player.currentItem?.playerID {
                        Player.playPause(playerID: playerID)
                    }
                }
            }, label: {
                Label("Play", systemImage: player.properties.speed == 1 ? "pause.fill" : "play.fill")
            })
            .disabled(player.currentItem == nil)
            .help(
                player.properties.speed == 1 ? "Pause your playlist" :
                    player.properties.playlistPosition == -1 ? "Start your playlist" :
                    "Continue playing your playlist"
            )
        }
    }

    /// Play the previous item
    ///
    /// - Note: Kodi is a bit weird; going to 'previous' goes to the beginning of an item when it played for a while; else it reallly goes to the previous item
    struct PlayPrevious: View {
        /// The KodiPlayer model
        @EnvironmentObject var player: KodiPlayer
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = player.currentItem?.playerID {
                        Player.goTo(playerID: playerID, direction: .previous)
                    }
                }
            }, label: {
                Label("Previous", systemImage: "backward.fill")
            })
            /// Disable when not playing
            .disabled(player.properties.playlistPosition == -1)
            /// A stream cannpot 'goto
            .disabled(player.currentItem?.media == .stream)
        }
    }

    /// Play the next item
    struct PlayNext: View {
        /// The KodiPlayer model
        @EnvironmentObject var player: KodiPlayer
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = player.currentItem?.playerID {
                        Player.goTo(playerID: playerID, direction: .next)
                    }
                }
            }, label: {
                Label("Next", systemImage: "forward.fill")
            })
            /// Disable when not playing
            .disabled(player.properties.playlistPosition == -1)
            /// Disabled when we play the last item
            .disabled(player.currentItem?.id == player.currentPlaylist?.last?.id)
        }
    }

    /// Toggle shuffle button
    struct SetShuffle: View {
        /// The KodiPlayer model
        @EnvironmentObject var player: KodiPlayer
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = player.currentItem?.playerID {
                        Player.setShuffle(playerID: playerID)
                    }
                }
            }, label: {
                Label("Shuffle", systemImage: "shuffle")
                    .foregroundColor(player.properties.shuffled ? .white : .none)
                    .padding(2)
                    .background(
                        player.properties.shuffled ? Color.accentColor : Color.clear,
                        in: RoundedRectangle(cornerRadius: 4)
                    )
            })
            .help("Shuffle the playlist")
            .disabled(player.properties.partymode)
            .disabled(!player.properties.canShuffle)
            /// You can't shuffle when there is only one item in the playlist
            .disabled(player.currentPlaylist?.count == 1)
        }
    }

    /// Toggle repeat button
    struct SetRepeat: View {
        /// The KodiPlayer model
        @EnvironmentObject var player: KodiPlayer
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = player.currentItem?.playerID {
                        Player.setRepeat(playerID: playerID)
                    }
                }
            }, label: {
                Label("Repeat", systemImage: repeatingIcon)
                    .foregroundColor(player.properties.repeating == .off ? .none : .white)
                    .padding(2)
                    .background(
                        player.properties.repeating == .off ? Color.clear : Color.accentColor,
                        in: RoundedRectangle(cornerRadius: 4)
                    )
            })
            .disabled(player.properties.partymode)
            .disabled(!player.properties.canRepeat)
        }
        /// The icon to show for 'repeat'
        var repeatingIcon: String {
            /// Standard icon for 'repeat'
            var icon = "repeat"
            /// Overrule if needed
            if player.properties.repeating == .one {
                icon = "repeat.1"
            }
            return icon
        }
    }

    /// Partymode button (forced to audio)
    ///
    /// - Note: This will set 'Party Mode' for audio, I don't see a use of videos for this
    struct SetPartyMode: View {
        /// The KodiPlayer model
        @EnvironmentObject var player: KodiPlayer
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if player.properties.partymode {
                        Player.setPartyMode(playerID: .audio)
                    } else {
                        Player.open(partyMode: .music)
                    }
                }
            }, label: {
                Label(title: {
                    Text("Party Mode")
                }, icon: {
                    Image(systemName: "wand.and.stars.inverse")
                        .padding(2)
                        .foregroundColor(player.properties.partymode ? .white : .none)
                })
                .background(
                    player.properties.partymode ? Color.red : Color.clear,
                    in: RoundedRectangle(cornerRadius: 4)
                )
            })
            .help("Music party mode")
        }
    }

    #if !os(tvOS)
    /// Volume slider
    struct VolumeSlider: View {
        /// The KodiPlayer model
        @EnvironmentObject var player: KodiPlayer
        /// Init the View
        public init() {}
        /// The body of the View
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
                            Image(systemName: player.muted ? "speaker.slash.fill" : "speaker.fill")
                                .foregroundColor(player.muted ? .red : .primary)
                        }
                    )
                    .font(.caption)
                    // swiftlint:disable:next trailing_closure
                    Slider(
                        value: $player.volume,
                        in: 0...100,
                        onEditingChanged: { _ in
                            /// - Note: Using 'onEditingChanged' because that will only be trickered when using the slider
                            ///         and not when programmaticly changing its value after a notification.
                            logger("Volume changed: \(player.volume)")
                            Task {
                                await Application.setVolume(volume: player.volume)
                            }
                        }
                    )
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.caption)
                }
            }
            .frame(width: 160)
        }
    }
    #endif
}
