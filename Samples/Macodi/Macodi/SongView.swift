//
//  AlbumView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct SongView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    @State var songs: [Audio.Details.Song] = []
    var body: some View {
        Table(songs) {
            TableColumn("Title", value: \.title)
            TableColumn("Artist", value: \.displayArtist)
            TableColumn("Play count") { song in
                Text(song.playcount == 0 ? "Never played" : "Played \(song.playcount) times")
            }
            TableColumn("Add playcount") { song in
                Button(action: {
                    Task {
                        await song.markAsPlayed()
                    }
                }
                       , label: {
                    Text("played")
                    
                })
            }
            TableColumn("Toggle playcount") { song in
                Button(action: {
                    Task {
                        await song.togglePlayedState()
                    }
                }
                       , label: {
                    Text(song.playcount == 0 ? "Mark as played" : "Mark as new")
                    
                })
            }
            TableColumn("Play") { song in
                PlayButton(item: song)
            }
        }
        .task(id: kodi.library.songs) {
            songs = kodi.library.songs
        }
    }
}
