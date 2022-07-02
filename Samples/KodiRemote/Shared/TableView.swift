//
//  TableView.swift
//  KodiRemote
//
//  Created by Nick Berendsen on 02/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct TableView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var artists: [Audio.Details.Artist] = []
    var body: some View {
        VStack {
            Text("Artists")
                .font(.title)
            List {
                ForEach(artists) { artist in
                    HStack {
                        Text(artist.artist)
                            .foregroundColor(artist.isAlbumArtist ? .green : .red)
                        Text(artist.compilationArtist ? "COMP" : "ALBUM")
                    }
                }
            }
        }
        .task {
            artists = await AudioLibrary.getArtists2()
        }
    }
}
