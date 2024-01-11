//
//  KodiConnector+Connect.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyStructCache
import OSLog

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
        if cache, let libraryItems = try? Cache.get(key: "MyLibrary", as: Library.Items.self, folder: host.ip) {
            library = libraryItems
            Logger.library.info("Check for library updates")
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
            if status != .outdatedLibrary {
                setStatus(.loadedLibrary)
            }
        } else {
            library = await getLibrary()
            setStatus(.loadedLibrary)
        }
        favourites = await getFavourites()
        await setLibraryCache()
    }

    func makeConnection() {
        /// Connect to the websocket
        connectWebSocket()
        /// Save the selected host
        HostItem.saveSelectedHost(host: host)
    }

    func getKodiState() async {
        /// Get the properties of the host
        properties = await Application.getProperties()
        /// Get the addons of the host
        addons = await Addons.getAddons()
        /// Get the settings of the host
        settings = await Settings.getSettings()
        if host.player == .local {
            await KodiPlayer.shared.getPlayerProperties()
            await KodiPlayer.shared.getPlayerItem()
            /// Send the properties to the KodiPlayer Class
            await KodiPlayer.shared.setApplicationProperties(properties: properties)
        }
    }
}
