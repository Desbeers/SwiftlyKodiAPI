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
//                    /// New notification TEST
//                    do {
//                        let message = try JSONDecoder().decode(NotificationItemModel.self, from: text.data(using: .utf8)!)
//                        if message.method != .unknown {
//                            dump(message)
//                        }
//                    } catch {
//                        print(error)
//                    }

                    /// get the notification
                    guard let data = text.data(using: .utf8),
                          let notification = try? JSONDecoder().decode(NotificationItem.self, from: data),
                          notification.sender != self.kodiConnectorID
                    else {
                        /// Not an interesting notification
                        /// print(message)
                        /// Call ourself again to receive the next notification
                        self.receiveNotification()
                        return
                    }
                    logger("Notification: \(notification.method.rawValue)")
                    print(message)
                    
                    Task { @MainActor in
                        self.notification = notification
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
