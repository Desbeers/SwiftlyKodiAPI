//
//  ArtistView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MovieSetView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var movieSets: [Video.Details.MovieSet] = []
    var body: some View {
        
        Table(movieSets) {
            TableColumn("Title", value: \.title)
            TableColumn("Play count") { movieSet in
                Text(movieSet.playcount == 0 ? "Never played" : "Played \(movieSet.playcount) times")
            }
            TableColumn("Toggle playcount") { movieSet in
                Button(action: {
                    Task {
                        await movieSet.togglePlayedState()
                    }
                }
                       , label: {
                    Text(movieSet.playcount == 0 ? "Mark as played" : "Mark as new")
                    
                })
            }
        }
        .task(id: kodi.library.movieSets) {
            movieSets = kodi.library.movieSets
        }
    }
}
