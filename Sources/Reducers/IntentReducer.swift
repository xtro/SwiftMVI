// IntentReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation

/// Intent reducer is a user intent to do something.
public protocol IntentReducer {
    /// A representation of user’s intents that typically changes the ``MutableState`` or emits an ``EventReducer/Event``
    associatedtype Intent
    func reduce(intent: Intent)
}

public extension IntentReducer {
    func callAsFunction(_ intent: Intent) {
        reduce(intent: intent)
    }
}

/// ``IntentReducer`` extension of ``Processing``
public extension Processing where Self: IntentReducer {
    /// Processing a given ``IntentReducer/Intent``
    /// - Parameter intent: An ``IntentReducer/Intent``
    func intent(_ intent: Intent) {
        reduce(intent: intent)
    }
}

public extension IntentReducer {
    @discardableResult
    /// Bind a combine publisher to an ``Intent``
    /// - Parameters:
    ///   - publisher: A **Publisher** instance.
    ///   - onFail: Transform publisher's failure into an ``Intent``
    ///   - onComplete: Transform publisher's completion into an ``Intent``
    ///   - intent: Transform publisher's result into an ``Intent``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<P: Publisher>(_ publisher: P, receiveOn: DispatchQueue? = nil, onFail: Transformer<P.Failure, Intent>? = nil, onComplete: Transformer<Bool, Intent>? = nil, to intent: @escaping Transformer<P.Output, Intent>) -> AnyCancellable {
        publisher
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .finished:
                    if let onComplete = onComplete {
                        reduce(intent: onComplete(true))
                    }
                case let .failure(error):
                    if let onFail {
                        reduce(intent: onFail(error))
                    }
                }
            }, receiveValue: {
                reduce(intent: intent($0))
            })
    }
}

public extension IntentReducer {
    @discardableResult
    /// Bind an ``Observer`` an ``Intent``
    /// - Parameters:
    ///   - feature: A conformance of ``MutableState`` and **ObservableObject**.
    ///   - intent: Transform publisher's result into an ``Intent``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState>(_ feature: F, receiveOn: DispatchQueue? = nil, to intent: @escaping Transformer<F.State, Intent>) -> AnyCancellable {
        feature.statePublisher
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink {
                reduce(intent: intent($0))
            }
    }
}

public extension IntentReducer where Self: Observer {
    /// Bind an **ObservableObject**  to a ``Intent``.
    /// - Parameters:
    ///   - feature: A conformance of ``MutableState`` and **ObservableObject**.
    ///   - intent: Transform publisher's result into an ``Intent``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState>(_ feature: F, receiveOn: DispatchQueue? = nil, to intent: @escaping Transformer<F.State, Intent>) {
        bind(feature, receiveOn: receiveOn, to: intent).store(in: &cancellables)
    }
}

public extension IntentReducer where Self: Observer {
    /// Bind a combine publisher to an ``Intent``
    /// - Parameters:
    ///   - publisher: A **Publisher** instance.
    ///   - onFail: Transform publisher's failure into an ``Intent``
    ///   - onComplete: Transform publisher's completion into an ``Intent``
    ///   - intent: Transform publisher's result into an ``Intent``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<P: Publisher>(_ publisher: P, receiveOn: DispatchQueue? = nil, onFail: Transformer<P.Failure, Intent>? = nil, onComplete: Transformer<Bool, Intent>? = nil, to intent: @escaping Transformer<P.Output, Intent>) {
        bind(publisher, receiveOn: receiveOn, onFail: onFail, onComplete: onComplete, to: intent).store(in: &cancellables)
    }
}
