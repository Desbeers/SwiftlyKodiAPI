//
//  AlbumView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MusicVideoView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    @State var musicVideos: [Video.Details.MusicVideo] = []
    var body: some View {
        Table(musicVideos) {
            TableColumn("Title", value: \.title)
            TableColumn("Artist") { musicVideo in
                Text(musicVideo.artist.joined(separator: " - "))
            }
            TableColumn("Play count") { musicVideo in
                Text(musicVideo.playcount == 0 ? "Never played" : "Played \(musicVideo.playcount) times")
            }
            TableColumn("Add playcount") { musicVideo in
                Button(action: {
                    Task {
                        await musicVideo.markAsPlayed()
                    }
                }
                       , label: {
                    Text("played")
                    
                })
            }
            TableColumn("Toggle playcount") { musicVideo in
                Button(action: {
                    Task {
                        await musicVideo.togglePlayedState()
                    }
                }
                       , label: {
                    Text(musicVideo.playcount == 0 ? "Mark as played" : "Mark as new")
                    
                })
            }
            TableColumn("Stream") { musicVideo in
                MediaButtons.StreamItem(item: musicVideo)
            }
        }
        .task(id: kodi.library.musicVideos) {
            musicVideos = kodi.library.musicVideos
        }
    }
}
