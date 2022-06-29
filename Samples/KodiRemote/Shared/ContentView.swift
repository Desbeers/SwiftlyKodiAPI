//
//  ContentView.swift
//  Shared
//
//  Created by Nick Berendsen on 25/06/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        VStack {
            Text("Kodi Remote")
                .padding()
                .font(.title)
            Text("Notification: \(kodi.notification.method.rawValue)")
            HStack {
                MediaArt.NowPlaying()
                VStack {
                    Text(kodi.currentItem.title)
                        .font(.headline)
                    Text(kodi.currentItem.subtitle)
                        .font(.subheadline)
                }
            }
#if os(tvOS)
            HStack {
                MediaButtons.PlayPause()
                    .padding()
                MediaButtons.SetShuffle()
                    .background(kodi.playerProperties.shuffled ? Color.blue : Color.clear)
                    .foregroundColor(kodi.playerProperties.shuffled ? .white : .none)

                MediaButtons.SetRepeat()
                    .padding()
            }
            .buttonStyle(.plain)
#endif
            Button(action: {
                Task {
                    await KodiConnector.shared.reloadHost()
                }
            }, label: {
                Text("Reload library")
            })
            MediaButtons.Debug()
        }
        .padding()
        .toolbar {
            ToolbarItem {
                MediaButtons.PlayPause()
            }
            ToolbarItem {
                MediaButtons.SetShuffle()
            }
            ToolbarItem {
                MediaButtons.SetRepeat()
            }
        }
        .animation(.default, value: kodi.currentItem)
        .task(id: kodi.notification) {
            dump(kodi.notification)
        }
    }
}
