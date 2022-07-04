//
//  ArtistView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ArtistView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var artists: [Audio.Details.Artist] = []
    var body: some View {
        
        Table(artists) {
            
            TableColumn("Icon") { artist in
                //AsyncImage(url: URL(string: Files.getFullPath(file: artist.thumbnail, type: .art)))
                
                ArtView(thumbnail: artist.thumbnail)
                
                //AsyncImage(url: URL(string: artist.thumbnail))
            }
            TableColumn("Name", value: \.artist)
            TableColumn("Thumbnail", value: \.thumbnail)
            TableColumn("Album Artist") { artist in
                Text(artist.isAlbumArtist ? "Yes" : "No")
            }
        }
        .task(id: kodi.library.artists) {
            artists = kodi.library.artists
        }
    }
}
