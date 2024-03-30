//
//  Backport.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// Backport SwiftUI functions for easier multi-targeting
public struct Backport<Content> {
    /// The content of the backport
    public let content: Content
    /// Init the backport
    public init(_ content: Content) {
        self.content = content
    }
}

public extension View {
    /// The base for backport
    var backport: Backport<Self> { Backport(self) }
}

public extension Backport where Content: View {

    /// `focusSection` backport
    @ViewBuilder
    func focusSection() -> some View {
        content
#if os(macOS) || os(tvOS)
            .focusSection()
#endif
    }
}

public extension Backport where Content: View {

    /// `focusable` backport
    /// - Note: To make Buttons focusable on macOS
    @ViewBuilder
    func focusable() -> some View {
        content
#if os(macOS)
            .focusable()
#endif
    }
}

public extension Backport where Content: View {

    /// `hoverEffect` backport
    @ViewBuilder
    func hoverEffect() -> some View {
        content
#if os(visionOS)
            .hoverEffect()
            .defaultHoverEffect(.highlight)
#endif
    }
}

public extension Backport where Content: View {

    /// `navigationSubtitle` backport
    @ViewBuilder
    func navigationSubtitle(_ text: String) -> some View {
        content
#if os(macOS)
            .navigationSubtitle(text)
#endif
    }
}

public extension Backport where Content: View {

    /// `onExitCommand` backport
    @ViewBuilder
    func onExitCommand(perform action: (() -> Void)?) -> some View {
        content
#if os(macOS) || os(tvOS)
            .onExitCommand {
                action?()
            }
#endif
    }
}
