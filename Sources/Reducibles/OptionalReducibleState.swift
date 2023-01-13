// OptionalReducibleState.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation
import SwiftUI

public protocol OptionalReducibleState {
    associatedtype State
    typealias StatePublisher = PassthroughSubject<State, Never>
    var state: State? { nonmutating set get }
    var statePublisher: StatePublisher { get }
    init(_ state: State?)
}

@MainActor public extension Processing where Self: OptionalReducibleState {
    /// Updating a state
    /// - Parameter block: Handler for given state
    mutating func state(mutatingMap: @escaping @Sendable (State?) -> State?) async {
        state = mutatingMap(state)
    }

    mutating func state(mutatingUpdate: @escaping @Sendable (inout State?) -> Void) async {
        var newState = state
        mutatingUpdate(&newState)
        state = newState
    }

    mutating func state(mutatingMake: @escaping @Sendable () -> State?) async {
        state = mutatingMake()
    }

    func state(map: @escaping @Sendable (State?) -> State?) async {
        state = map(state)
    }

    func state(update: @escaping @Sendable (State?) -> Void) async {
        update(state)
    }

    func state(update: @escaping @Sendable (inout State?) -> Void) async {
        var newState = state
        update(&newState)
        state = newState
    }

    func state(make: @escaping @Sendable () -> State?) async where Self: AnyObject {
        state = make()
    }
}

public extension Processing where Self: OptionalReducibleState {
    mutating func state(mutatingMap: @escaping @Sendable (State?) -> State?) {
        state = mutatingMap(state)
    }

    mutating func state(mutatingUpdate: @escaping @Sendable (inout State?) -> Void) {
        var newState = state
        mutatingUpdate(&newState)
        state = newState
    }

    mutating func state(mutatingMake: @escaping @Sendable () -> State?) {
        state = mutatingMake()
    }

    func state(map: @escaping @Sendable (State?) -> State?) {
        state = map(state)
    }

    func state(update: @escaping @Sendable (State?) -> Void) {
        update(state)
    }

    func state(update: @escaping @Sendable (inout State?) -> Void) {
        var newState = state
        update(&newState)
        state = newState
    }

    func state(make: @escaping @Sendable () -> State?) where Self: AnyObject {
        state = make()
    }
}

///// Processing a ``ReducableState`` of an ``Observer``
// @MainActor public extension Processing where Self: ReducibleState, Self: Observer {
//    func state(update: Bool = true, animation: Animation? = nil, block: @escaping (State) -> Void) async {
//        block(state)
//        if update {
//            if let animation = animation {
//                withAnimation(animation) {
//                    objectWillChange.send()
//                }
//            } else {
//                objectWillChange.send()
//            }
//        }
//    }
// }
//
///// Processing a ``ReducableState`` of an ``Observer``
// public extension Processing where Self: ReducibleState, Self: Observer {
//    func state(update: Bool = true, animation: Animation? = nil, block: @escaping (State) -> Void) {
//        block(state)
//        if update {
//            if let animation = animation {
//                withAnimation(animation) {
//                    objectWillChange.send()
//                }
//            } else {
//                objectWillChange.send()
//            }
//        }
//    }
// }
