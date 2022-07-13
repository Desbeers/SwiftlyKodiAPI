//
//  MusicBrowserView.swift
//  Macodi
//
//  Created by Nick Berendsen on 12/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MusicBrowserView: View {
    
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    @State var browser = BrowserModel()
    @State var library = BrowserLibrary()
    @State var selection = BrowserSelection()
    
    var body: some View {
        
        Self._printChanges()
        
        return VStack {
            HStack {
                genres
                artists
                albums
            }
            songs
        }
        .task(id: kodi.library.songs) {
            print("LIBRARY TASK")
            
            library.genres = kodi.library.audioGenres
            library.artists = kodi.library.artists.filter({$0.isAlbumArtist})
            library.albums = kodi.library.albums.sorted { $0.title < $1.title }
            //library.albums = kodi.library.albums.filter({$0.compilation == false}).sorted { $0.title < $1.title }
//            let artistAlbums = library.albums.map( { $0.albumID } )
//            /// Filter the songs
//            library.songs =  kodi.library.songs.filter({artistAlbums.contains($0.albumID)}).sorted { $0.title < $1.title }
            
            library.songs =  kodi.library.songs.sorted { $0.title < $1.title }
            
            filter()
        }
        .animation(.default, value: browser.songs)
        .onChange(of: selection) { _ in
            filter()
        }
        
//        .task(id: selection) {
//            print("SELECTION TASK")
//            filter()
//        }
    }
}

extension MusicBrowserView {
    
    func filter() {
        print("Filter library")
        var artists = library.artists
        var albums = library.albums
        var songs = library.songs

        if let genre = selection.selectedGenre {
            songs = songs.filter({$0.genreID.contains(genre.genreID)})
            albums = albums.filter({$0.genre.contains(genre.title)})
            artists = artists.filter({$0.songGenres.compactMap({$0.genreID}).contains(genre.genreID)})
        }
        
        if let artist = selection.selectedArtist {
            songs = songs.filter({$0.albumArtistID.contains(artist.artistID)})
            albums = albums.filter({$0.artistID.contains(artist.artistID)}).sorted { $0.year < $1.year }
            //albums = kodi.library.albums.filter({albumID.contains($0.albumID)})
        }
        
        if let album = selection.selectedAlbum {
            songs = songs.filter({$0.albumID == album.albumID}).sorted { $0.track < $1.track }
        }
        
        browser = BrowserModel(genres: library.genres, artists: artists, albums: albums, songs: songs)
        

    }
    
    var genres: some View {
        ScrollView {
            LazyVStack {
                ForEach(browser.genres) { genre in
                    Button(action: {
                        selection.selectedGenre = selection.selectedGenre == genre ? nil : genre
                        selection.selectedArtist = nil
                        selection.selectedAlbum = nil
                    }, label: {
                        Text(genre.title)
                            .foregroundColor(selection.selectedGenre == genre ? Color.green : Color.primary)
                    })
                }
            }
        }
    }
    
    var artists: some View {
        ScrollView {
            LazyVStack {
                ForEach(browser.artists) { artist in
                    Button(action: {
                        
                        
                        selection = BrowserSelection(selectedAlbum: nil,
                                                     selectedArtist: selection.selectedArtist == artist ? nil : artist,
                                                     selectedGenre: selection.selectedGenre
                        )
                    }, label: {
                        Text(artist.title)
                            .foregroundColor(selection.selectedArtist == artist ? Color.green : Color.primary)
                    })
                }
            }
        }
    }
    
    
    var albums: some View {
        ScrollView {
            LazyVStack {
                ForEach(browser.albums) { album in
                    Button(action: {
                        selection.selectedAlbum = selection.selectedAlbum == album ? nil : album
                    }, label: {
                        Text(album.title)
                            .foregroundColor(selection.selectedAlbum == album ? Color.green : Color.primary)
                    })
                }
            }
        }
    }
    
    var songs: some View {
        ScrollView {
            LazyVStack {
                ForEach(browser.songs) { song in
                    HStack {
                        Text(song.title)
                            .font(.headline)
                        Text("\(song.track)")
                        Text(song.artist.joined(separator: " - "))
                            .font(.subheadline)
                        Text(song.album)
                        Text("Played: \(song.playcount)")
                    }
                }
            }
        }
    }
    
    struct BrowserModel: Equatable {
        var genres: [Library.Details.Genre] = []
        var artists: [Audio.Details.Artist] = []
        var albums: [Audio.Details.Album] = []
        var songs: [Audio.Details.Song] = []
        
//        var selectedAlbum: Audio.Details.Album?
//        var selectedArtist: Audio.Details.Artist?
//        var selectedGenre: Library.Details.Genre?
        
        //var library = BrowserLibrary()
        
    }
    
    struct BrowserSelection: Equatable {
        var selectedAlbum: Audio.Details.Album?
        var selectedArtist: Audio.Details.Artist?
        var selectedGenre: Library.Details.Genre?
    }
    
    struct BrowserLibrary: Equatable {
        var genres: [Library.Details.Genre] = []
        var artists: [Audio.Details.Artist] = []
        var albums: [Audio.Details.Album] = []
        var songs: [Audio.Details.Song] = []
    }
    
}
