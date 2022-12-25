// ReducibleState.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

import Foundation

/// A type that describes the data your feature needs to perform its logic and render its UI.
public protocol ReducibleState {
    associatedtype State
    var state: State { get }
}

@MainActor public extension Processing where Self: ReducibleState {
    /// Updating a state
    /// - Parameter block: Handler for given state
    func state(block: @escaping (State) -> Void) {
        block(state)
    }
}
