//
//  PlayButton.swift
//  Macodi
//
//  Created by Nick Berendsen on 12/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct PlayButton: View {
    
    @Environment(\.openWindow) var openWindow
    
    let item: any KodiItem
    var body: some View {
        Button(action: {
            openWindow(value: item)
        }, label: {
            Text("Play")
        })
        .buttonStyle(.bordered)
    }
}
