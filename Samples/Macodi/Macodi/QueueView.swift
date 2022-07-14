//
//  QueueView.swift
//  Macodi
//
//  Created by Nick Berendsen on 13/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct QueueView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        Group {
            if kodi.queue == nil {
                Text("Queue is empty")
            } else {
                ScrollView {
                    ForEach(kodi.queue!, id: \.id) { item in
                        switch item {
                        case let song as Audio.Details.Song:
                            MusicBrowserView.Song(song: song)
                        default:
                            Text(item.title)
                        }
                        Divider()
                    }
                }
            }
        }
    }
}
