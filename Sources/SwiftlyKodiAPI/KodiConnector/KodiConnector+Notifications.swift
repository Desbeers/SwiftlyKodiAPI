//
//  KodiConnector+Notifications.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

public extension Notification.Name {
    static let kodiNotification = Notification.Name("KodiNotification")
}

extension KodiConnector {

    /// Recieve a notification from the Kodi WebSocket
    ///  - Note: Messages send by ourself are ignored
    func receiveNotification() {
        webSocketTask?.receive { result in
            /// Call ourself again to receive the next notification
            /// - Note: `defer` this call to the last action when this function is done
            defer {
                self.receiveNotification()
            }
            /// Handle the notification
            switch result {
            case .success(let message):
                if case .string(let text) = message {
                    /// get the notification
                    guard
                        let data = text.data(using: .utf8),
                        let notification = try? JSONDecoder().decode(Notifications.Item.self, from: data),
                        notification.sender != self.host.ip
                    else {
                        /// Not an interesting notification
                        Logger.notice.notice("Received an unknown notification")
                        return
                    }
                    Logger.notice.notice("Received '\(notification.method.rawValue)' notification")

                    /// Pass the notice to the notification center
                    Task { @MainActor in
                        NotificationCenter.default.post(name: Notification.Name.kodiNotification, object: notification)
                    }

                    /// Perform notification action
                    Task {
                        await self.notificationAction(notification: notification)
                    }
                }
            case .failure:
                /// Failures are handled by the delegate
                break
            }
        }
    }
}

extension KodiConnector {

    /// Perform an action after recieving a notification from the Kodi host
    /// - Parameter notification: The received notification
    func notificationAction(notification: Notifications.Item) async {

        /// General notifications
        switch notification.method {

        case .audioLibraryOnScanStarted, .audioLibraryOnCleanStarted:
            if host.media == .audio || host.media == .all {
                scanningLibrary = true
                Task {
                    await setStatus(.updatingLibrary)
                }
            }

        case .videoLibraryOnScanStarted, .videoLibraryOnCleanStarted:
            if host.media == .video || host.media == .all {
                scanningLibrary = true
                Task {
                    await setStatus(.updatingLibrary)
                }
            }

        case .audioLibraryOnScanFinished, .audioLibraryOnCleanFinished:
            if host.media == .audio || host.media == .all {
                scanningLibrary = false
                /// Load the library again
                Task {
                    await loadLibrary()
                }
            }

        case .videoLibraryOnScanFinished, .videoLibraryOnCleanFinished:
            if host.media == .video || host.media == .all {
                scanningLibrary = false
                /// Load the library again
                Task {
                    await loadLibrary()
                }
            }
        case .audioLibraryOnRemove, .videoLibraryOnRemove:
            if !scanningLibrary && host.libraryContent.contains(notification.media) {
                deleteKodiItem(itemID: notification.itemID, media: notification.media)
            }

        case .audioLibraryOnUpdate, .videoLibraryOnUpdate:
            if !scanningLibrary && host.libraryContent.contains(notification.media) {
                updateKodiItem(itemID: notification.itemID, media: notification.media)
                await getCurrentPlaylist(host: host, media: notification.media)
            }

        case .videoLibraryOnRefresh:
            Task { @MainActor in
                settings = await Settings.getSettings(host: host)
            }
        default:
            break
        }

        /// Player notifications
        if host.player == .local {
            switch notification.method {

            case .applicationOnVolumeChanged:
                await player.setApplicationProperties(
                    properties: await Application.getProperties(host: host)
                )
            case .playerOnPropertyChanged, .playerOnPause, .playerOnResume:
                await player.setProperties(
                    properties: await Player.getProperties(host: host, playerID: notification.playerID)
                )
                await getCurrentPlaylist(host: host, media: notification.media)

            case .playerOnSeek:
                await getPlayerProperties()

            case .playlistOnAdd, .playlistOnRemove, .playlistOnClear:
                await getCurrentPlaylist(host: host, media: notification.media)

            default:
                await getPlayerProperties()
                await getPlayerItem()
            }
        }
    }
}
