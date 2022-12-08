//
//  KodiConnector+Connect.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: Connecting and loading functions

extension KodiConnector {

    public func connect(host: HostItem) {
        /// Start with a blank sheet
        Task {
            await setState(.offline)
        }
        self.host = host
        if host.isOnline {
            makeConnection()
        }
    }

    func makeConnection() {
        connectWebSocket()
    }

    func getKodiState() async {
        await KodiPlayer.shared.getPlayerProperties()
        await KodiPlayer.shared.getPlayerItem()
        /// Get the properties of the host
        properties = await Application.getProperties()
        /// Get the settings of the host
        Task { @MainActor in
            settings = await Settings.getSettings()
        }
        /// Send the properties to the KodiPlayer Class
        await KodiPlayer.shared.setApplicationProperties(properties: properties)
    }

    @MainActor func getCurrentPlaylists() async {
        /// Get Player playlists
        await KodiPlayer.shared.getCurrentPlaylist(media: .none)
        /// Get User playlists
        library.audioPlaylists = await Files.getDirectory(directory: "special://musicplaylists", media: .music)
    }

    @MainActor public func loadLibrary(cache: Bool = true) async {
        setState(.loadingLibrary)
        if cache, let libraryItems = Cache.get(key: "MyLibrary", as: Library.Items.self) {
            library = libraryItems
            if host.media == .audio {
                await getAudioLibraryUpdates()
            } else {
                setState(.loadedLibrary)
            }
        } else {
            library = await getLibrary()
            await setLibraryCache()
            setState(.loadedLibrary)
        }

    }
}

extension KodiConnector {

    /// Get all video genres from the Kodi host
    /// - Returns: All video genres from the Kodi host
    func getAllVideoGenres() async -> [Library.Details.Genre] {
        /// Get the genres for all media types
        let movieGenres = await VideoLibrary.getGenres(type: .movie)
        let tvGenres = await VideoLibrary.getGenres(type: .tvshow)
        let musicGenres = await VideoLibrary.getGenres(type: .musicVideo)
        /// Combine and return them
        return (movieGenres + tvGenres + musicGenres).unique { $0.id}
    }
}
