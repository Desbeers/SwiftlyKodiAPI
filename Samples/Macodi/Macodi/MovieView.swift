//
//  MovieView.swift
//  Macodi
//
//  Created by Nick Berendsen on 05/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MovieView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var movies: [Video.Details.Movie] = []
    var body: some View {
        
        Table(movies) {
            TableColumn("Name", value: \.title)
            TableColumn("Ratings") { movie in

                if let rating = movie.ratings.defaults {
                    Text("Rating: \(rating.rating), \(rating.votes) votes")
                } else {
                    Text("No rating")
                }
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
        .task(id: kodi.library.movies) {
            movies = kodi.library.movies
        }
    }
}

