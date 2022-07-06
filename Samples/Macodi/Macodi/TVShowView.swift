//
//  ArtistView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct TVShowView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var tvshows: [Video.Details.TVShow] = []
    var body: some View {
        
        Table(tvshows) {
            TableColumn("Title", value: \.title)
            
            TableColumn("Watched") { tvshow in
                Text("Watched \(tvshow.watchedEpisodes) episodes")
            }
            
            TableColumn("Status") { tvshow in
                
                if let status = tvshow.status {
                    Text(status)
                } else {
                    Text("Unknown")
                }
            }
            TableColumn("Play count") { tvshow in
                Text(tvshow.playcount == 0 ? "Never played" : "Played \(tvshow.playcount) times")
            }
            TableColumn("Toggle playcount") { tvshow in
                Button(action: {
                    Task {
                        await tvshow.togglePlayedState()
                    }
                }
                       , label: {
                    Text(tvshow.playcount == 0 ? "Mark as played" : "Mark as new")
                    
                })
            }
        }
        .task(id: kodi.library.tvshows) {
            tvshows = kodi.library.tvshows
        }
    }
}
