//
//  AlbumView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct CompilationView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    @State var songs: [Audio.Details.Song] = []
    var body: some View {
        Table(songs) {
            TableColumn("Title", value: \.title)
            TableColumn("Artist", value: \.displayArtist)
            TableColumn("Album", value: \.album)
            TableColumn("Play count") { song in
                Text(song.playcount == 0 ? "Never played" : "Played \(song.playcount) times")
            }
            TableColumn("Add playvount") { song in
                Button(action: {
                    Task {
                        await song.markAsPlayed()
                    }
                }
                       , label: {
                    Text("played")
                    
                })
            }
        }
        .task(id: kodi.library.songs) {
            /// Get all album ID's that are compilations
            let compilationAlbums = kodi.library.albums.filter({$0.compilation == true}).map( { $0.albumID } )
            /// Filter the songs
            songs =  kodi.library.songs.filter({compilationAlbums.contains($0.albumID)})
        }
    }
}
