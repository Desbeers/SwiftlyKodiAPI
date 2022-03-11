//
//  File.swift
//  
//
//  Created by Nick Berendsen on 10/03/2022.
//

import Foundation

extension KodiConnector {
    
    /// Recieve a notification from the Kodi WebSocket
    ///  - Note: Messages send by ourself are ignored
    func receiveNotification() {
        webSocketTask?.receive { result in
            switch result {
            case .success(let message):
                if case .string(let text) = message {
                    print(text)
                    /// get the notification
                    guard let data = text.data(using: .utf8),
                          let notification = try? JSONDecoder().decode(NotificationItem.self, from: data),
                          let type = NotificationMethod(rawValue: notification.method),
                          notification.params.sender != self.kodiConnectorID
                    else {
                        /// Not an interesting notification
                        /// print(message)
                        /// Call ourself again to receive the next notification
                        self.receiveNotification()
                        return
                    }
                    logger("Notification: \(type.rawValue)")
                    
                    Task { @MainActor in
                        self.notification = type
                    }
                    
                    //self.notificationAction(notification: notification)
                }
                /// Call ourself again to receive the next notification
                self.receiveNotification()
            case .failure:
                /// Failures are handled by the delegate
                break
            }
        }
    }
}
