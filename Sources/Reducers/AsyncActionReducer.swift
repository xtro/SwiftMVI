// AsyncActionReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation

/// **AsyncActionReducer** is a special types of action reducers. It can returns a Reaction or throws an error.
public protocol AsyncActionReducer {
    /// An action.
    associatedtype Action
    /// Async action reducer
    /// - Parameter action: ``Action`` to reduce.
    func reduce(action: Action) async
}

public extension Processing where Self: AsyncActionReducer {
    /// Processing a given ``AsyncActionReducer/Action`` asynchroniously.
    /// - Parameter action: An ``AsyncActionReducer/Action``.
    func action(_ action: Action) async {
        await reduce(action: action)
    }
}

public extension AsyncActionReducer {
    @discardableResult
    func callAsFunction(action: Action, priority: TaskPriority? = nil) -> Task<Void, Never> {
        Task.detached(priority: priority) { [self] in
            await reduce(action: action)
        }
    }
}

public extension AsyncActionReducer where Self: ReducibleState {
    @discardableResult
    /// Receive state change from an observable object and transforms it to an ``Effect``
    /// - Parameters:
    ///   - feature: A conformance of ``ReducibleState`` and **ObservableObject**.
    ///   - action: Transform state of feature into an ``Effect``.
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState>(_ feature: F, receiveOn: DispatchQueue? = nil, to action: @escaping Transformer<F.State, Action>) -> AnyCancellable {
        feature.statePublisher
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink {
                self(action: action($0))
            }
    }
}

public extension AsyncActionReducer where Self: ReducibleState & Observer {
    /// Receive state change from an observable object and transforms it to an ``Event``
    /// - Parameters:
    ///   - feature: A conformance of ``MutableState`` and **ObservableObject**.
    ///   - action: Transform state of feature into an ``Event``.
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState>(_ feature: F, receiveOn: DispatchQueue? = nil, to action: @escaping Transformer<F.State, Action>) {
        bind(feature, receiveOn: receiveOn, to: action).store(in: &cancellables)
    }
}
