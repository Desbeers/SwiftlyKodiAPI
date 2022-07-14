//
//  ButtonStyles.swift
//  Macodi
//
//  Created by Nick Berendsen on 13/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// Button style for a library item
struct ButtonStyleLibraryItem: ButtonStyle {
    /// The kodi item
    let item: any KodiItem
    /// Bool if selected or not
    let selected: Bool
    /// The style
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .background(
                VStack {
                    Rectangle().fill(Color.accentColor.gradient)
                    //Color.accentColor.gradient
                }.saturation(selected ? 1 : buttonSaturation(item: item))
            )
            .cornerRadius(6)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .padding(.vertical, 2)
            .padding(.trailing, 8)
    }
    
    /// Saturate a button
    /// - Parameter media: The media type
    /// - Returns: A saturation value
    private func buttonSaturation(item: any KodiItem) -> Double {
        switch item.media {
        case .album:
            return 0.4
        case .artist:
            return 0.25
        case .genre:
            return 0.1
        default:
            return 1.0
        }
    }
}
