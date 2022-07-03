//
//  SidebarView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI

struct SidebarView: View {
    var body: some View {
        List {
            NavigationLink(destination: ArtistView()) {
                Text("Artists")
            }
            NavigationLink(destination: AlbumView()) {
                Text("Albums")
            }
        }
    }
}
