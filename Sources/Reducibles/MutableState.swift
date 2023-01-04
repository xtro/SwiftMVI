// MutableState.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

import Foundation
import SwiftUI

@available(*, deprecated)
public typealias ReducibleState = MutableState

/// A type that describes the data your feature needs to perform its logic and render its UI.
public protocol MutableState {
    associatedtype State
    var state: State { get }
}

@MainActor public extension Processing where Self: MutableState {
    /// Updating a state
    /// - Parameter block: Handler for given state
    func state(block: @escaping (State) -> Void) {
        block(state)
    }
}

/// Processing a ``ReducableState`` of an ``Observer``
@MainActor public extension Processing where Self: MutableState, Self: Observer {
    func state(update: Bool = true, animation: Animation? = nil, block: @escaping (State) -> Void) async {
        block(state)
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
public extension Processing where Self: MutableState, Self: Observer {
    func state(update: Bool = true, animation: Animation? = nil, block: @escaping (State) -> Void) {
        block(state)
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
