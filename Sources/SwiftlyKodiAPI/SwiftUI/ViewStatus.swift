//
//  ViewStatus.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The status of  loading a View
/// - Note: This `enum`  can be used in SwiftUI Views that load items via a `Task`
public enum ViewStatus: Sendable {
    /// The Task is loading the items
    case loading
    /// No items where found by the `Task`
    case empty
    /// The `Task` is done and items where found
    case ready
    /// The Kodi host is offline, the `Task' cannot load content
    case offline
}

extension ViewStatus {
    
    /// SwiftUI View with the status message
    /// - Parameters:
    ///   - router: The current ``Router``
    ///   - progress: Show progress when loading content
    /// - Returns: A SwiftUI View
    @ViewBuilder public func message(router: Router, progress: Bool = false) -> some View {
        if self == .loading {
            switch progress {
            case true:
                ContentUnavailableView {
                    Label(
                        title: { Text(router.item.title) },
                        icon: { ProgressView() }
                    )
                } description: {
                        Text(router.item.loading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case false:
                /// - Note: Don't use EmptyView() because otherwise animations are weird
                Color.clear
            }
        } else {
            ContentUnavailableView {
                Label(router.item.title, systemImage: router.item.icon)
            } description: {
                switch self {
                case .empty:
                    Text(router.item.empty)
                case .offline:
                    Text("The host is offline")
                default:
                    Text("")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
