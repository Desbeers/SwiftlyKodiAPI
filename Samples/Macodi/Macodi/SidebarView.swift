//
//  SidebarView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI

struct SidebarView: View {
    @State var selection: String?
    var body: some View {
        List(selection: $selection) {
            Section(header: Text("Audio")) {
                NavigationLink(destination: ArtistView()) {
                    Label("Artists", systemImage: "person.2")
                }
                .tag("artists")
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
                NavigationLink(destination: MusicBrowserView()) {
                    Label("Browser", systemImage: "circle.grid.cross")
                }
            }
            Section(header: Text("Video")) {
                NavigationLink(destination: MovieView()) {
                    Label("Movies", systemImage: "film")
                }
                NavigationLink(destination: MovieSetView()) {
                    Label("Movie sets", systemImage: "film")
                }
                NavigationLink(destination: TVShowView()) {
                    Label("TV Shows", systemImage: "tv")
                }
                NavigationLink(destination: EpisodeView()) {
                    Label("Episodes", systemImage: "tv")
                }
                NavigationLink(destination: MusicVideoView()) {
                    Label("Music Videos", systemImage: "music.note")
                }
                NavigationLink(destination: VideoGenreView()) {
                    Label("Genres", systemImage: "circle.grid.cross")
                }
            }
        }
    }
}
