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
                        dump(message)
                        return
                    }
                    //debugJsonResponse(data: data)
                    logger("Notification: \(notification.method.rawValue)")
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
        
        logger(notification.method.rawValue)
        
        switch notification.method {

        case .audioLibraryOnUpdate, .videoLibraryOnUpdate:
            getLibraryUpdate(itemID: notification.itemID, media: notification.media)
            await KodiPlayer.shared.getCurrentPlaylist()
        case .playlistOnAdd,.playlistOnRemove, .playlistOnClear:
            await KodiPlayer.shared.getCurrentPlaylist()
//            await getCurrentPlaylist()
//            //break
        case .applicationOnVolumeChanged:
            Task {
                properties = await Application.getProperties()
                await KodiPlayer.shared.setApplicationProperties(properties: properties)
            }
        case .playerOnPropertyChanged, .playerOnPause, .playerOnResume:
            await KodiPlayer.shared.setProperties(properties: await Player.getProperties(playerID: notification.playerID))
        case .playerOnSeek:
            await KodiPlayer.shared.getPlayerProperties()
        default:
            //logger("Default actions after notification")
            await KodiPlayer.shared.getPlayerProperties()
            await KodiPlayer.shared.getPlayerItem()
            //await KodiPlayer.shared.getCurrentPlaylist()
        }
    }
}
