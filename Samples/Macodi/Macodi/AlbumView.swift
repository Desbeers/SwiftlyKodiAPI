//
//  AlbumView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct AlbumView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var albums: [Audio.Details.Album] = []
    var body: some View {
        
        Table(albums) {
            
//            TableColumn("Icon") { artist in
//                //AsyncImage(url: URL(string: Files.getFullPath(file: artist.thumbnail, type: .art)))
//                AsyncImage(url: URL(string: artist.thumbnail))
//            }
            TableColumn("Title", value: \.title)
            TableColumn("Release Type") { album in
                Text(album.releaseType.rawValue)
            }
//            TableColumn("Thumbnail", value: \.thumbnail)
//            TableColumn("Album Artist") { artist in
//                Text(artist.isAlbumArtist ? "Yes" : "No")
//            }
        }
        .task {
            albums = await AudioLibrary.getAlbums2()
        }
    }
}
