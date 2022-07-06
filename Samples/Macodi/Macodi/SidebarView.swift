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
            Section(header: Text("Audio")) {
                NavigationLink(destination: ArtistView()) {
                    Label("Artists", systemImage: "person.2")
                }
                NavigationLink(destination: AlbumView()) {
                    Label("Albums", systemImage: "square.stack")
                }
                NavigationLink(destination: SongView()) {
                    Label("All songs", systemImage: "music.note")
                }
                NavigationLink(destination: CompilationView()) {
                    Label("Compilation songs", systemImage: "link")
                }
                NavigationLink(destination: AudioGenreView()) {
                    Label("Genres", systemImage: "circle.grid.cross")
                }
            }
            Section(header: Text("Video")) {
                NavigationLink(destination: MovieView()) {
                    Label("Movies", systemImage: "film")
                }
                NavigationLink(destination: TVShowView()) {
                    Label("TV Shows", systemImage: "tv")
                }
                NavigationLink(destination: EpisodeView()) {
                    Label("Episodes", systemImage: "tv")
                }
            }
        }
    }
}
