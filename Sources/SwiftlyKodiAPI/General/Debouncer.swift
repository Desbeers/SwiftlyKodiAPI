//
//  Debouncer.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

actor Debouncer {
    private let duration: TimeInterval
    private var task: Task<Void, Error>?

    init(duration: TimeInterval) {
        self.duration = duration
    }

    func submit(operation: @escaping () async -> Void) {
        task?.cancel()

        task = Task {
            try await sleep()
            await operation()
            task = nil
        }
    }

    func sleep() async throws {
        try await Task.sleep(nanoseconds: UInt64(duration * TimeInterval(NSEC_PER_SEC)))
    }
}

/// Debounce functions
struct Tasks {
    var getCurrentPlaylist = Debouncer(duration: 2)
    var setLibraryCache = Debouncer(duration: 10)
    var getPlayerState = Debouncer(duration: 4)
    var getPlayerProperties = Debouncer(duration: 2)
    var getPlayerItem = Debouncer(duration: 2)
}
