//
//  AlbumView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct VideoGenreView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var genres: [Library.Details.Genre] = []
    var body: some View {
        
        Table(genres) {
            TableColumn("Title", value: \.title)
            TableColumn("Genre ID") { genre in
                Text("\(genre.genreID)")
            }
        }
        .task(id: kodi.library.videoGenres) {
            genres = kodi.library.videoGenres
        }
    }
}
