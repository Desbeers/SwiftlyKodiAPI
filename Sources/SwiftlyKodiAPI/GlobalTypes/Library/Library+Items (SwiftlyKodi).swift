//
//  Library+Items.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Library {

    /// The items in the library (SwiftlyKodi Type)
    struct Items: Codable, Equatable, Sendable {
        /// The artist in the library
        public var artists: [Audio.Details.Artist] = []
        /// The albums in the library
        public var albums: [Audio.Details.Album] = []
        /// The songs in the library
        public var songs: [Audio.Details.Song] = []
        /// The audio genres in the library
        public var audioGenres: [Library.Details.Genre] = []
        /// The audio playlists iin the library
        public var audioPlaylists: [List.Item.File] = []
        /// The state of the audio library
        public var audioLibraryProperties = Audio.Property.Value()
        /// The movies in the library
        public var movies: [Video.Details.Movie] = []
        /// The movie sets in the library
        public var movieSets: [Video.Details.MovieSet] = []
        /// The TV shows in the library
        public var tvshows: [Video.Details.TVShow] = []
        /// The TV show episodes in the library
        public var episodes: [Video.Details.Episode] = []
        /// The music videos in the library
        public var musicVideos: [Video.Details.MusicVideo] = []
        /// The movie playlists in the library
        public var moviePlaylists: [List.Item.File] = []
        /// The video genres in the library
        public var videoGenres: [Library.Details.Genre] = []
    }
}
