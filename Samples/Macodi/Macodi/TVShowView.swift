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
            TableColumn("Status") { tvshow in
                
                if let status = tvshow.status {
                    Text(status)
                } else {
                    Text("Unknown")
                }
            }
        }
        .task(id: kodi.library.tvshows) {
            tvshows = kodi.library.tvshows
        }
    }
}
