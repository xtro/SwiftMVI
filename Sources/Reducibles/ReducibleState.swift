// ReducibleState.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation
import SwiftUI

public protocol ReducibleState {
    associatedtype State
    typealias StatePublisher = CurrentValueSubject<State, Never>
    var state: State { get nonmutating set }
    var statePublisher: StatePublisher { get }
    func setup(state: State)
}

public protocol HasDefault {
    static var `default`: Self { get }
}

public extension ReducibleState {
    func setup(state: State) {
        self.state = state
//        statePublisher = .init(state)
    }

    func setup(state _: State) where State: HasDefault {
        state = State.default
//        statePublisher = .init(state)
    }
}

public extension Processing where Self: ReducibleState {
    func state(update _: Bool = true, animation _: Animation? = nil, map: @escaping @Sendable (State) -> State) where Self: AnyObject {
        state = map(state)
        updateState(reducer: self)
    }

    func state(update _: Bool = true, animation _: Animation? = nil, mutate: @escaping @Sendable (State) -> Void) where Self: AnyObject {
        mutate(state)
        updateState(reducer: self)
    }

    func state(update _: Bool = true, animation _: Animation? = nil, mutate: @escaping @Sendable (inout State) -> Void) where Self: AnyObject {
        var newState = state
        mutate(&newState)
        state = newState
        updateState(reducer: self)
    }

    func state(update _: Bool = true, animation _: Animation? = nil, make: @escaping @Sendable () -> State) where Self: AnyObject {
        state = make()
        updateState(reducer: self)
    }
}

private func updateState(reducer: some ReducibleState, update: Bool = true, animation: Animation? = nil) {
    if update {
        if let animation = animation {
            withAnimation(animation) {
                reducer.statePublisher.send(reducer.state)
            }
        } else {
            reducer.statePublisher.send(reducer.state)
        }
    }
}

@MainActor public extension Processing where Self: ReducibleState {
    /// Updating a state
    /// - Parameter block: Handler for given state
    mutating func state(update _: Bool = true, animation _: Animation? = nil, map: @escaping @Sendable (State) -> State) async where Self: AnyObject {
        state = map(state)
        await updateState(reducer: self)
    }

    func state(update _: Bool = true, animation _: Animation? = nil, mutate: @escaping @Sendable (State) -> Void) async where Self: AnyObject {
        mutate(state)
        await updateState(reducer: self)
    }

    mutating func state(update _: Bool = true, animation _: Animation? = nil, mutate: @escaping @Sendable (inout State) -> Void) async {
        var newState = state
        mutate(&newState)
        state = newState
        await updateState(reducer: self)
    }

    func state(update _: Bool = true, animation _: Animation? = nil, make: @escaping @Sendable () -> State) async {
        state = make()
        await updateState(reducer: self)
    }
}

@MainActor
private func updateState(reducer: some ReducibleState, update: Bool = true, animation: Animation? = nil) async {
    if update {
        if let animation = animation {
            withAnimation(animation) {
                reducer.statePublisher.send(reducer.state)
            }
        } else {
            reducer.statePublisher.send(reducer.state)
        }
    }
}


public extension ReducibleState {
    var statePublisher: StatePublisher {
        Observed<State>.firstObserved(on: self, value: state) ?? StatePublisher(state)
    }
}
