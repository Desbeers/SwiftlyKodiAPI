//
//  KodiConnector+Connect.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
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
            await setStatus(.connecting)
            await setHost(host)
            if bonjourHosts.contains(where: { $0.name == host.name }) {
                await setStatus(.online)
            }
        }
    }

    /// Load the library
    /// - Parameter cache: Bool if it should try to load the library from the cache
    public func loadLibrary(cache: Bool = true) async {
        await setStatus(.loadingLibrary)
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
                await setStatus(.loadedLibrary)
            }
        } else {
            library = await getLibrary()
            await setStatus(.loadedLibrary)
        }
        favourites = await getFavourites()
        await setLibraryCache()
    }

    func makeConnection() async {
        /// Connect to the websocket
        connectWebSocket()
        /// Save the selected host
        HostItem.saveSelectedHost(host: host)
        /// Get all List sortings
        listSortSettings = KodiListSort.getAllSortSettings(host: host)
        if host.media != .none {
            await loadLibrary()
        }
        await getKodiState()
    }

    func getKodiState() async {
        /// Get the properties of the host
        properties = await Application.getProperties(host: host)
        /// Get the addons of the host
        addons = await Addons.getAddons(host: host)
        /// Get the settings of the host
        settings = await Settings.getSettings(host: host)
        if host.player == .local {
            await getPlayerProperties()
            await getPlayerItem()
            /// Send the properties to the KodiPlayer Class
            await player.setApplicationProperties(properties: properties)
        }
    }
}
