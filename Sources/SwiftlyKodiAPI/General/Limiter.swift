//
//  Limiter.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

actor Limiter {
    private let policy: Policy
    private let duration: TimeInterval
    private var task: Task<Void, Error>?

    init(policy: Policy, duration: TimeInterval) {
        self.policy = policy
        self.duration = duration
    }

    func submit(operation: @escaping () async -> Void) {
        switch policy {
        case .throttle: throttle(operation: operation)
        case .debounce: debounce(operation: operation)
        }
    }
}

// MARK: - Limiter.Policy

extension Limiter {
    enum Policy {
        case throttle
        case debounce
    }
}

// MARK: - Private utility methods

private extension Limiter {
    func throttle(operation: @escaping () async -> Void) {
        guard task == nil else { return }

        task = Task {
            try? await sleep()
            task = nil
        }

        Task {
            await operation()
        }
    }

    func debounce(operation: @escaping () async -> Void) {
        task?.cancel()
        
        task = Task {
            try await sleep()
            await operation()
            task = nil
        }
    }

    func sleep() async throws {
        try await Task.sleep(nanoseconds: UInt64(duration * .nanosecondsPerSecond))
    }
}

// MARK: - TimeInterval

extension TimeInterval {
    static let nanosecondsPerSecond = TimeInterval(NSEC_PER_SEC)
}
