//Library.swift
//  SwiftlyKodiAPI
//  
//  Created by Nick Berendsen on 18/02/2022.
//

import SwiftUI

extension KodiConnector {
    
    /// Get a Binding from a ``MediaItem`` to the Kodi library
    ///
    /// In SwiftUI, if you filter the media items in a `ForEach` you can't use the 'normal' Binding $ anymore
    /// - Parameter item: A Media item
    /// - Returns: A Binding to the Kodi library
    func getLibraryBinding(item: MediaItem) -> Binding<MediaItem> {
        return  Binding<MediaItem>(
            get: { self.media.first(where: { $0.id == item.id}) ?? item },
            set: { newValue in
                /// Nothing to do here...
            }
        )
    }
}
