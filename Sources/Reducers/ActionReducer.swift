// ActionReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

import Combine
import Foundation

/// Action reducer is defines a process of doing something to achive an aim or fails. Its a type that represents all of the actions that can happen in your feature, such as notifications, event sources, other features and more
///
/// Typically used instead of ``IntentReducer/Intent`` in cases when ``ReducibleState`` did not needed.
public protocol ActionReducer {
    /// A representation of an action
    associatedtype Action
    /// Action reducer is a function that describes how to evolve the current state of the app to the next state given an action. The reducer is also responsible for throwing any errors, if something unexpected happens.
    /// - Parameter action: ``Action`` to reduce.
    func reduce(action: Action) throws
}

public extension ActionReducer where Self: ObservableObject {
    @discardableResult
    /// Bind a combine publisher to an ``Action``
    /// - Parameters:
    ///   - publisher: A **Publisher** instance.
    ///   - onFail: Transform publisher's failure into an ``Action``
    ///   - onComplete: Transform publisher's completion into an ``Action``
    ///   - action: Transform publisher's result into an ``Action``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<P: Publisher>(_ publisher: P, receiveOn: DispatchQueue? = nil, onFail: Transformer<P.Failure, Action>? = nil, onComplete: Transformer<Bool, Action>? = nil, to action: @escaping Transformer<P.Output, Action>) -> AnyCancellable {
        publisher
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] complete in
                switch complete {
                case .finished:
                    if let onComplete = onComplete {
                        try? self?.reduce(action: onComplete(true))
                    }
                case let .failure(error):
                    if let onFail = onFail {
                        try? self?.reduce(action: onFail(error))
                    }
                }
            }, receiveValue: { [weak self] output in
                try? self?.reduce(action: action(output))
            })
    }
}

public extension ActionReducer where Self: ObservableObject {
    @discardableResult
    /// Receive state change from an observable object and transforms it to an ``Action``.
    /// - Parameters:
    ///   - feature: A  feature contains a``ReducibleState`` and it should be an ``ObservableObject``.
    ///   - action: Transform the state of feature into an ``Action``.
    /// - Returns: A cancellable instance of **AnyCancellable**..
    func bind<F: ReducibleState & ObservableObject>(_ feature: F, receiveOn: DispatchQueue? = nil, to action: @escaping Transformer<F.State, Action>) -> AnyCancellable {
        feature.objectWillChange
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink { [weak self] _ in
                try? self?.reduce(action: action(feature.state))
            }
    }
}

/// ``ActionReducer`` extension of ``Processing``
public extension Processing where Self: ActionReducer {
    /// Processing a given ``ActionReducer/Action``
    /// - Parameter action: An ``ActionReducer/Action``
    func action(_ action: Action) throws {
        try reduce(action: action)
    }
}

public extension ActionReducer where Self: Observer {
    /// Bind a combine publisher to an ``Action``
    /// - Parameters:
    ///   - publisher: A  combine publisher
    ///   - onFail: Transform publisher's failure into an ``Action``
    ///   - onComplete: Transform publisher's completion into an ``Action``
    ///   - action: Transform publisher's result into an ``Action``
    /// - Returns: A cancellable instance of AnyCancellable.
    func bind<P: Publisher>(_ publisher: P, receiveOn: DispatchQueue? = nil, onFail: Transformer<P.Failure, Action>? = nil, onComplete: Transformer<Bool, Action>? = nil, to action: @escaping Transformer<P.Output, Action>) {
        bind(publisher, receiveOn: receiveOn, onFail: onFail, onComplete: onComplete, to: action).store(in: &cancellables)
    }
}

public extension ActionReducer where Self: Observer {
    /// Receive state change from an observable object and transforms it to an ``Action``
    /// - Parameters:
    ///   - feature: A ``ReducibleState`` and an ObservableObject.
    ///   - action: Transform state of feature into an ``Action``.
    /// - Returns: A cancellable instance of AnyCancellable.
    func bind<F: ReducibleState & ObservableObject>(_ feature: F, receiveOn: DispatchQueue? = nil, to action: @escaping Transformer<F.State, Action>) {
        bind(feature, receiveOn: receiveOn, to: action).store(in: &cancellables)
    }
}
