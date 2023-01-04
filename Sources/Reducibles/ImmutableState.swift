// MutableState.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

import Foundation
import SwiftUI

/// A type that describes the data your feature needs to perform its logic and render its UI.
public protocol ImmutableState: AnyObject {
    associatedtype State: Sendable
    var state: State { set get }
}

@MainActor public extension Processing where Self: ImmutableState {
    /// Updating a state
    /// - Parameter block: Handler for given state
    func state(block: @escaping @Sendable (State) -> State) {
        state = block(state)
    }
}

/// Processing a ``ReducableState`` of an ``Observer``
@MainActor public extension Processing where Self: ImmutableState, Self: Observer {
    func state(update: Bool = true, animation: Animation? = nil, block: @escaping (State) -> State) async {
        state = block(state)
        if update {
            if let animation = animation {
                withAnimation(animation) {
                    objectWillChange.send()
                }
            } else {
                objectWillChange.send()
            }
        }
    }
}

/// Processing a ``ReducableState`` of an ``Observer``
public extension Processing where Self: ImmutableState, Self: Observer {
    func state(update: Bool = true, animation: Animation? = nil, block: @escaping (State) -> State) {
        state = block(state)
        if update {
            if let animation = animation {
                withAnimation(animation) {
                    objectWillChange.send()
                }
            } else {
                objectWillChange.send()
            }
        }
    }
}
