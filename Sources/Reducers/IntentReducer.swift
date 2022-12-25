// IntentReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

import Combine
import Foundation

/// Intent reducer is a user intent to do something.
public protocol IntentReducer {
    /// A representation of user’s intents that typically changes the ``ReducibleState`` or emits an ``EventReducer/Event``
    associatedtype Intent
    func reduce(intent: Intent)
}

public extension IntentReducer {
    func callAsFunction(_ intent: Intent) {
        reduce(intent: intent)
    }
}

public extension IntentReducer where Self: ObservableObject {
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
            .sink(receiveCompletion: { [weak self] complete in
                switch complete {
                case .finished:
                    if let onComplete = onComplete {
                        self?.reduce(intent: onComplete(true))
                    }
                case let .failure(error):
                    if let onFail = onFail {
                        self?.reduce(intent: onFail(error))
                    }
                }
            }, receiveValue: { [weak self] output in
                self?.reduce(intent: intent(output))
            })
    }
}

public extension IntentReducer where Self: ObservableObject {
    @discardableResult
    /// Bind an ``Observer`` an ``Intent``
    /// - Parameters:
    ///   - feature: A conformance of ``ReducibleState`` and **ObservableObject**.
    ///   - intent: Transform publisher's result into an ``Intent``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState & ObservableObject>(_ feature: F, receiveOn: DispatchQueue? = nil, to intent: @escaping Transformer<F.State, Intent>) -> AnyCancellable {
        feature.objectWillChange
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reduce(intent: intent(feature.state))
            }
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

public extension IntentReducer where Self: Observer {
    /// Bind an **ObservableObject**  to a ``Intent``.
    /// - Parameters:
    ///   - feature: A conformance of ``ReducibleState`` and **ObservableObject**.
    ///   - intent: Transform publisher's result into an ``Intent``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState & ObservableObject>(_ feature: F, receiveOn: DispatchQueue? = nil, to intent: @escaping Transformer<F.State, Intent>) {
        bind(feature, receiveOn: receiveOn, to: intent).store(in: &cancellables)
    }
}
