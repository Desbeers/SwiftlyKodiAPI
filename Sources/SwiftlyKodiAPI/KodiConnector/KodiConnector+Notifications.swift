//
//  KodiConnector+Notifications.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

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
                    guard let data = text.data(using: .utf8),
                          let notification = try? JSONDecoder().decode(Notifications.Item.self, from: data),
                          notification.sender != self.kodiConnectorID
                    else {
                        /// Not an interesting notification
                        logger("Unknown notification")
                        return
                    }
                    //debugJsonResponse(data: data)
                    //logger("Notification: \(notification.method.rawValue)")
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
        switch notification.method {

        case .audioLibraryOnUpdate, .videoLibraryOnUpdate:
            getLibraryUpdate(itemID: notification.itemID, media: notification.media)
            await getCurrentPlaylist()
        case .playlistOnAdd, .playlistOnClear:
            await getCurrentPlaylist()
            //break
        case .applicationOnVolumeChanged:
            Task { @MainActor in
                properties = await Application.getProperties()
            }
        default:
            //logger("Default actions after notification")
            await getPlayerState()
            await getCurrentPlaylist()
        }
    }
}
