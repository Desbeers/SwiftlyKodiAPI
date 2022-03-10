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
                    /// get the notification
                    guard let data = text.data(using: .utf8),
                          let notification = try? JSONDecoder().decode(NotificationItem.self, from: data),
                          let method = Method(rawValue: notification.method),
                          notification.params.sender != self.kodiConnectorID
                    else {
                        /// Not an interesting notification
                        /// print(message)
                        /// Call ourself again to receive the next notification
                        self.receiveNotification()
                        return
                    }
                    logger("Notification: \(method.rawValue)")
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
    
    /// The notification item
    struct NotificationItem: Decodable {
        /// The method
        var method: String
        /// The params
        var params = Params()
        /// The params struct
        struct Params: Decodable {
            /// The optional data from the notice
            var data: DataItem?
            /// The sender of the notice
            var sender: String = ""
        }
        /// The struct for the notification data
        struct DataItem: Decodable {
            /// The item ID
            var itemID: Int?
            /// The type of item
            var type: String?
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                /// The keys
                case type
                /// ID is a reserved word
                case itemID = "id"
            }
        }
    }
}
