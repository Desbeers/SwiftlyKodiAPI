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
            HStack {
                MediaArt.NowPlaying()
                VStack {
                    Text(kodi.currentItem.title)
                        .font(.headline)
                    Text(kodi.currentItem.subtitle)
                        .font(.subheadline)
                }
            }

            MediaButtons.PlayPause()
                .padding()
            //MediaButtons.GetItem()
            Button(action: {
                Task {
                    await KodiConnector.shared.reloadHost()
                }
            }, label: {
                Text("Reload library")
            })
        }
    }
}
