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
    
    struct StreamItem: View {
        let item: any LibraryItem
        public init(item: any LibraryItem) {
            self.item = item
        }
        public var body: some View {
            Button(action: {
                //PlayItem(item: song)
                // create a new NSPanel
                let window = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500), styleMask: [.fullSizeContentView, .closable, .resizable, .titled], backing: .buffered, defer: false)
                
                // the styleMask can contails more, like borderless, hudWindow...
                
                window.center()
                
                // put your swiftui view here in rootview
                window.contentView = NSHostingView(rootView: PlayerView(item: item))
                window.makeKeyAndOrderFront(nil)
            }
                   , label: {
                Text("Stream")
                
            })
        }
    }
    
    /// Debug button
    struct Debug: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() {}
        public var body: some View {
            Button(action: {
                Task {
                    await AudioLibrary.getArtists()
                    //let artist = Audio.Details.Artist()
                    //dump(artist)
//                    print("All Video Genres")
//                    let genres = await kodi.getAllGenres()
                    //dump(genres)
//                    print("ALL EPISODES")
//                    await VideoLibrary.getEpisodes()
//                    print("TV SHOW EPISODES")
//                    await VideoLibrary.getEpisodes(tvshowID: 170)
//                    print("LAST PLAYED")
//                    await AudioLibrary.getSongs(
//                        sort: List.Sort(method: .lastPlayed, order: .descending),
//                        limits: List.Limits(end: 10)
//                    )
//                    print("SPECIFIC ALBUM")
//                    await AudioLibrary.getSongs(
//                        filter: List.Filter(albumID: 3),
//                        sort: List.Sort(method: .track, order: .ascending)
//                    )
                }
            }, label: {
                Text("Debug")
            })
        }
    }
}

