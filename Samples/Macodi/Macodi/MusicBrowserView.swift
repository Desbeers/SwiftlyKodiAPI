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
    
    let browserType: BrowserType
    
    var body: some View {
        Group {
            if browser.songs.isEmpty {
                ProgressView()
            } else {
                VStack {
                    HStack {
                        genres
                        artists
                        albums
                    }
                    songs
                }
            }
        }
        /// Load the library
        .task(id: kodi.library.songs) {
            filterLibrary()
        }
        /// Filter the browser when a selection has changed
        .onChange(of: selection) { _ in
            filterBrowser()
        }
        /// Just some eyecandy
        //.animation(.default, value: browser.songs)
    }
}

extension MusicBrowserView {
    
    
    /// Filter the library by ``BrowserType-swift.enum``
    ///
    /// The browser library is based on songs; they are filtered first and then the rest is added
    func filterLibrary() {
        /// Get all songs from the library
        let songs =  kodi.library.songs.sorted { $0.title < $1.title }
        /// Filter the songs
        switch browserType {
        case .recentlyAdded:
            library.songs = Array(
                songs.sorted {
                        $0.dateAdded > $1.dateAdded
                    }
                    .prefix(100)
            )
        case .recentlyPlayed:
            library.songs = Array(
                songs.sorted {
                        $0.lastPlayed > $1.lastPlayed
                    }
                    .prefix(100)
            )
        case .favorites:
            library.songs = songs
                .filter {
                    $0.userRating > 0
                }
                .sorted {
                    $0.userRating > $1.userRating
                }
        default:
            library.songs = songs
        }
        /// All albums in the browser
        let songAlbums = library.songs.map( { $0.albumID } )
        library.albums = kodi.library.albums.filter({songAlbums.contains($0.albumID)}).sorted { $0.title < $1.title }
        /// All artists in the browser
        let songArtists = library.songs.flatMap( { $0.albumArtistID } ).removingDuplicates()
        library.artists = kodi.library.artists.filter({songArtists.contains($0.artistID)}).sorted { $0.sortByTitle < $1.sortByTitle }
        /// All genres in the browser
        let songGenres = library.songs.flatMap( { $0.genreID } ).removingDuplicates()
        library.genres = kodi.library.audioGenres.filter({songGenres.contains($0.genreID)})
        /// Filter the browser based on selection
        filterBrowser()
    }
    
    func filterBrowser() {
        print("Filter browser")
        var artists = library.artists
        var albums = library.albums
        var songs = library.songs

        if let genre = selection.selectedGenre {
            songs = songs.filter({$0.genreID.contains(genre.genreID)})
            albums = albums.filter({$0.genre.contains(genre.title)})
            
            let songArtists = songs.flatMap( { $0.albumArtistID } ).removingDuplicates()
            artists = artists.filter({songArtists.contains($0.artistID)}).sorted { $0.title < $1.title }
        }
        
        if let artist = selection.selectedArtist {
            songs = songs.filter({$0.albumArtistID.contains(artist.artistID)})
            albums = albums.filter({$0.artistID.contains(artist.artistID)}).sorted { $0.year < $1.year }
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
                            .padding()
                            //.foregroundColor(selection.selectedGenre == genre ? Color.green : Color.primary)
                    })
                    .buttonStyle(ButtonStyleLibraryItem(item: genre, selected: selection.selectedGenre == genre))
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
                        HStack {
                            KodiArt.Poster(item: artist)
                                .frame(width: 80, height: 80)
                            Text(artist.title)
                                //.foregroundColor(selection.selectedArtist == artist ? Color.green : Color.primary)
                        }
                    })
                    .buttonStyle(ButtonStyleLibraryItem(item: artist, selected: selection.selectedArtist == artist))
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
                        HStack {
                            KodiArt.Poster(item: album)
                                .frame(width: 80, height: 80)
                            
                            VStack(alignment: .leading) {
                                Text(album.title)
                                Text(album.displayArtist)
                                    .font(.subheadline)
                                    .opacity(0.8)
                                Text("\(album.year.description) ∙ \(album.genre.joined(separator: "∙"))")
                                    .font(.caption)
                                    .opacity(0.6)
                            }
                                //.foregroundColor(selection.selectedAlbum == album ? Color.green : Color.primary)
                        }
                    })
                    .buttonStyle(ButtonStyleLibraryItem(item: album, selected: selection.selectedAlbum == album))
                }
            }
        }
    }
    
    var songs: some View {
        VStack {
            HStack {
                Button(action: {
                    browser.songs.play()
                }, label: {
                    Text("Play songs")
                })
                Button(action: {
                    browser.songs.play(shuffle: true)
                }, label: {
                    Text("Shuffle songs")
                })
            }
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(browser.songs) { song in
                        Song(song: song)
                        Divider()
                    }
                }
            }
        }
    }
    
    struct Song: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        let song: Audio.Details.Song
        var body: some View {
            HStack {
                icon
                VStack(alignment: .leading) {
                    Text(song.title)
                    Text(song.displayArtist)
                        .font(.subheadline)
                        .opacity(0.8)
                    Text(song.album)
                        .font(.caption)
                        .opacity(0.6)
                    Text(song.lastPlayed)
                    Text("Playcount: \(song.playcount)")
                    Text("Rating: \(song.userRating)")
                }
                PlayButton(item: song)
                Button(action: {
                    Task {
                        await song.togglePlayedState()
                    }
                }, label: {
                    Text(song.playcount == 0 ? "Mark as played" : "Mark as new")
                    
                })
                Button(action: {
                    Task {
                        await song.toggleFavorite()
                    }
                }, label: {
                    Text(song.userRating == 0 ? "Favorite" : "Unfavorite")
                    
                })
            }
        }
        /// The icon for the song item
        @ViewBuilder var icon: some View {
            if song.songID == kodi.currentItem?.id {
                if kodi.player.speed == 0 {
                    Image(systemName: "pause.fill")
                } else {
                    Image(systemName: "play.fill")
                }
            } else {
                Image(systemName: song.userRating == 0 ? "music.note" : "heart")
            }
        }
    }
    

    
    struct BrowserModel: Equatable {
        var genres: [Library.Details.Genre] = []
        var artists: [Audio.Details.Artist] = []
        var albums: [Audio.Details.Album] = []
        var songs: [Audio.Details.Song] = []
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
    
    enum BrowserType {
        case all
        case recentlyAdded
        case recentlyPlayed
        case mostPlayed
        case favorites
    }
    
}
