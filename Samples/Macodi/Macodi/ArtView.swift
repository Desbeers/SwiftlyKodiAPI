//
//  ArtView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ArtView: View {
    
    let thumbnail: String
    
    var body: some View {
        
        if !thumbnail.isEmpty {
            
            AsyncImage(url: URL(string: Files.getFullPath(file: thumbnail, type: .art))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } placeholder: {
                Color.black
                    .frame(width: 40, height: 40)
            }
        }
    }
}
