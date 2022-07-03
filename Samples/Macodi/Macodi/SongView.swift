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
            
//            TableColumn("Icon") { artist in
//                //AsyncImage(url: URL(string: Files.getFullPath(file: artist.thumbnail, type: .art)))
//                AsyncImage(url: URL(string: artist.thumbnail))
//            }
            TableColumn("Title", value: \.title)
            TableColumn("Artist", value: \.displayArtist)
//            TableColumn("Release Type") { album in
//                Text(album.releaseType.rawValue)
//            }
//            TableColumn("Thumbnail", value: \.thumbnail)
//            TableColumn("Album Artist") { artist in
//                Text(artist.isAlbumArtist ? "Yes" : "No")
//            }
        }
        .task {
            songs = await AudioLibrary.getSongs2(limits: List.Limits(end: 400, start: 100))
            //songs = await AudioLibrary.getSongs2()
        }
    }
}
