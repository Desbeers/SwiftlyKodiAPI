//
//  KodiConnector+Connect.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: Connecting and loading functions

extension KodiConnector {

    /// Get the last selected host, if any, and try connect to it
    public func getSelectedHost() {
        if let host = HostItem.getSelectedHost() {
            connect(host: host)
        }
    }

    /// Connect to a specifiv host
    /// - Parameter host: The configured ``HostItem``
    public func connect(host: HostItem) {
        /// Start with a blank sheet
        Task {
            await setStatus(.offline)
        }
        self.host = host
        if host.isOnline {
            makeConnection()
        }
    }

    /// Load the library
    /// - Parameter cache: Bool if it should try to load the library from the cache
    @MainActor public func loadLibrary(cache: Bool = true) async {
        setStatus(.loadingLibrary)
        if cache, let libraryItems = Cache.get(key: "MyLibrary", as: Library.Items.self) {
            library = libraryItems
            logger("Check for updates")
            switch host.media {
            case .audio:
                await getAudioLibraryUpdates()
            case .video:
                await getVideoLibraryUpdates()
            case .all:
                await getAudioLibraryUpdates()
                await getVideoLibraryUpdates()
            case .none:
                break
            }
        } else {
            library = await getLibrary()
        }
        setStatus(.loadedLibrary)
        await setLibraryCache()
    }

    func makeConnection() {
        /// Connect to the websocket
        connectWebSocket()
        /// Save the selected host
        HostItem.saveSelectedHost(host: host)
    }

    func getKodiState() async {
        await KodiPlayer.shared.getPlayerProperties()
        await KodiPlayer.shared.getPlayerItem()
        /// Get the properties of the host
        properties = await Application.getProperties()
        /// Get the addons of the host
        addons = await Addons.getAddons()
        /// Get the settings of the host
        Task { @MainActor in
            settings = await Settings.getSettings()
        }
        /// Send the properties to the KodiPlayer Class
        await KodiPlayer.shared.setApplicationProperties(properties: properties)
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
