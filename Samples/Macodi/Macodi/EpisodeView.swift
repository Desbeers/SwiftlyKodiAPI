//
//  ArtistView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct EpisodeView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var episodes: [Video.Details.Episode] = []
    var body: some View {
        
        Table(episodes) {
            TableColumn("Show", value: \.showTitle)
            TableColumn("Title", value: \.title)
            TableColumn("Number") { episode in
                Text("Season \(episode.season), episode \(episode.episode)")
            }
            TableColumn("Play count") { movie in
                Text(movie.playcount == 0 ? "Never played" : "Played \(movie.playcount) times")
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
            TableColumn("Stream") { movie in
                MediaButtons.StreamItem(item: movie)
            }
        }
        .task(id: kodi.library.episodes) {
            episodes = kodi.library.episodes
        }
    }
}
