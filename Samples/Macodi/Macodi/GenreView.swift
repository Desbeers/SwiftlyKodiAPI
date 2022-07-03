//
//  AlbumView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct GenreView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var genres: [Library.Details.Genre] = []
    var body: some View {
        
        Table(genres) {
            TableColumn("Title", value: \.title)
            TableColumn("Source ID") { genre in
                VStack {
                    ForEach(genre.sourceID, id: \.self) {source in
                        Text("\(source)")
                    }
                }
            }
        }
        .task {
            genres = await AudioLibrary.getGenres()
        }
    }
}
