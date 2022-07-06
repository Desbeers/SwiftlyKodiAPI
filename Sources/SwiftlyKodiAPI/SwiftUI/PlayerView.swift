//
//  SwiftUIView.swift
//  
//
//  Created by Nick Berendsen on 05/07/2022.
//

import SwiftUI
import AVKit


/// PlayerView
struct PlayerView: View {
    init(item: any LibraryItem) {
        self.item = item
    }
    
    @EnvironmentObject var kodi: KodiConnector
    let item: any LibraryItem
    
    public var body: some View {
        Text(item.media.rawValue)
        Text(item.file)
        VideoPlayer(player: AVPlayer(url:  URL(string: Files.getFullPath(file: item.file, type: .file))!))
    }
}
