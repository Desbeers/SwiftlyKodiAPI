//
//  Debouncer.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

/// Debounce a Task for a certain time
actor Debouncer {
    // Debounce duration in seconds
    private let duration: Int
    /// The debounce task
    private var task: Task<Void, Error>?

    /// Init the Actor
    /// - Parameter duration: Debounce duration in seconds
    init(duration: Int) {
        self.duration = duration
    }

    /// Submit a 'debouncable' Task
    /// - Parameter operation: The Task
    func submit(operation: @escaping () async -> Void) {
        task?.cancel()
        task = Task {
            try await sleep()
            await operation()
            task = nil
        }
    }
    /// Let the task sleep for a moment
    func sleep() async throws {
        try await Task.sleep(until: .now + .seconds(duration), clock: .continuous)
    }
}

/// Debounce functions
struct Tasks {
    var getCurrentPlaylist = Debouncer(duration: 2)
    var setLibraryCache = Debouncer(duration: 4)
    var getPlayerState = Debouncer(duration: 4)
    var getPlayerProperties = Debouncer(duration: 2)
    var getPlayerItem = Debouncer(duration: 2)
}
