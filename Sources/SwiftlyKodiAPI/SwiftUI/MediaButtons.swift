//
//  MediaButtons.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

// MARK: Media Buttons

/// Collection of SwiftUI media buttons (SwiftlyKodi Type)
///
/// The Views require to have the ``KodiPlayer`` Observable Class in the 'environment' or else your Application will crash
///
/// - Note: The buttons are smart and will be disabled when not applicable
/// - Note: Buttons with a help modifier do not work on visionOS
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
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        var help: String {
            kodi.player.properties.speed == 1 ? "Pause your playlist" :
            kodi.player.properties.playlistPosition == -1 ? "Start your playlist" :
                "Continue playing your playlist"
        }
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = kodi.player.currentItem?.playerID {
                        Player.playPause(host: kodi.host, playerID: playerID)
                    }
                }
            }, label: {
                Label("Play", systemImage: kodi.player.properties.speed == 1 ? "pause.fill" : "play.fill")
            })
            .mediaButtonStyle(help: help)
            .disabled(kodi.player.currentItem == nil)
        }
    }

    /// Play the previous item
    ///
    /// - Note: Kodi is a bit weird; going to 'previous' goes to the beginning of an item when it played for a while; else it reallly goes to the previous item
    struct PlayPrevious: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = kodi.player.currentItem?.playerID {
                        Player.goTo(host: kodi.host, playerID: playerID, direction: .previous)
                    }
                }
            }, label: {
                Label("Previous", systemImage: "backward.fill")
            })
            .mediaButtonStyle(help: "Previous")
            /// Disable when not playing
            .disabled(kodi.player.properties.playlistPosition == -1)
            /// A stream cannpot 'goto
            .disabled(kodi.player.currentItem?.media == .stream)
        }
    }

    /// Play the next item
    struct PlayNext: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = kodi.player.currentItem?.playerID {
                        Player.goTo(host: kodi.host, playerID: playerID, direction: .next)
                    }
                }
            }, label: {
                Label("Next", systemImage: "forward.fill")
            })
            .mediaButtonStyle(help: "Next")
            /// Disable when not playing
            .disabled(kodi.player.properties.playlistPosition == -1)
            /// Disabled when we play the last item
            .disabled(kodi.player.currentItem?.id == kodi.player.currentPlaylist?.last?.id)
        }
    }

    /// Toggle shuffle button
    struct SetShuffle: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = kodi.player.currentItem?.playerID {
                        Player.setShuffle(host: kodi.host, playerID: playerID)
                    }
                }
            }, label: {
                Label("Shuffle", systemImage: "shuffle")
            })
            .mediaButtonStyle(background: kodi.player.properties.shuffled, help: "Shuffle the playlist")
            .disabled(kodi.player.properties.partymode)
            .disabled(!kodi.player.properties.canShuffle)
            /// You can't shuffle when there is only one item in the playlist
            .disabled(kodi.player.currentPlaylist?.count == 1)
        }
    }

    /// Toggle repeat button
    struct SetRepeat: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if let playerID = kodi.player.currentItem?.playerID {
                        Player.setRepeat(host: kodi.host, playerID: playerID)
                    }
                }
            }, label: {
                Label("Repeat", systemImage: repeatingIcon)
            })
            .mediaButtonStyle(background: !(kodi.player.properties.repeating == .off), help: "Repeat")
            .disabled(kodi.player.properties.partymode)
            .disabled(!kodi.player.properties.canRepeat)
        }
        /// The icon to show for 'repeat'
        var repeatingIcon: String {
            /// Standard icon for 'repeat'
            var icon = "repeat"
            /// Overrule if needed
            if kodi.player.properties.repeating == .one {
                icon = "repeat.1"
            }
            return icon
        }
    }

    /// Partymode button (forced to audio)
    ///
    /// - Note: This will set 'Party Mode' for audio, I don't see a use of videos for this
    struct SetPartyMode: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(action: {
                Task {
                    if kodi.player.properties.partymode {
                        Player.setPartyMode(host: kodi.host, playerID: .audio)
                    } else {
                        Player.open(host: kodi.host, partyMode: .music)
                    }
                }
            }, label: {
                Label(title: {
                    Text("Party Mode")
                }, icon: {
                    Image(systemName: "wand.and.stars.inverse")
                })
            })
            .mediaButtonStyle(background: kodi.player.properties.partymode, color: .red, help: "Music party mode")
        }
    }

#if !os(tvOS)
    /// Volume mute
    struct VolumeMute: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            Button(
                action: {
                    Task {
                        await Application.setMute(host: kodi.host)
                    }
                },
                label: {
                    Label(
                        title: {
                            Text("Mute")
                        },
                        icon: {
                            Image(systemName: kodi.player.muted ? "speaker.slash.fill" : "speaker.fill")
                        }
                    )
                }
            )
            .mediaButtonStyle(background: kodi.player.muted, color: .red, help: "Mute")
        }
    }
#endif

#if !os(tvOS)
    /// Volume slider
    struct VolumeSlider: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// Init the View
        public init() {}
        /// The body of the View
        public var body: some View {
            @Bindable var player = kodi.player
            Slider(
                value: $player.volume,
                in: 0...100,
                label: {
                    Text("Volume")
                },
                onEditingChanged: { _ in
                    /// - Note: Using 'onEditingChanged' because that will only be trickered when using the slider
                    ///         and not when programmaticly changing its value after a notification.
                    Logger.player.info("Volume changed: \(player.volume)")
                    Task {
                        await Application.setVolume(host: kodi.host, volume: player.volume)
                    }
                }
            )
            .frame(minWidth: 120)
        }
    }
#endif
}

public extension MediaButtons {

    struct MediaLabelStyle: LabelStyle {
        /// Bool if the button should have a background
        var background: Bool = false
        /// The background color
        var color: Color = .accentColor
        /// The modifier
        public func makeBody(configuration: Configuration) -> some View {
            configuration
                .icon
                .foregroundStyle(background ? .white : .secondary)
                .padding(4)
                .background(
                    background ? color.opacity(1) : Color.clear
                )
                .cornerRadius(4)
        }
    }

    struct MediaButtonStyle: ViewModifier {
        /// Bool if the button should have a background
        let background: Bool
        /// The background color
        let color: Color
        /// The optional help
        var help: String?
        /// The modifier
        public func body(content: Content) -> some View {
            content
#if os(macOS)
            /// 'foregroundStyle' is ignored by macOS so style the label instead
                .buttonStyle(.plain)
                .labelStyle(MediaLabelStyle(background: background, color: color))
                .help(help ?? "")
#elseif os(iOS)
                .buttonStyle(.plain)
                .padding(8)
                .foregroundStyle(background ? .white : .secondary)
                .background(
                    background ? color : Color.clear
                )
                .cornerRadius(8)
#else
            /// visionOS
                .buttonStyle(.bordered)
                .tint(background ? color : .clear)
#endif
        }
    }
}

extension View {

    public func mediaButtonStyle(
        background: Bool = false,
        color: Color = .accentColor,
        help: String? = nil
    ) -> some View {
        modifier(
            MediaButtons.MediaButtonStyle(
                background: background,
                color: color,
                help: help
            )
        )
    }
}
