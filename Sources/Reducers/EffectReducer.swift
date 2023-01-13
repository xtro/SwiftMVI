// EffectReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation

/// Effect reducer is an internal type of ``IntentReducer/Intent`` in cases when ``MutableState`` is not needed.
public protocol EffectReducer {
    associatedtype Effect
    func reduce(effect: Effect)
}

public extension EffectReducer {
    @discardableResult
    /// Bind a combine publisher to an ``Effect``
    /// - Parameters:
    ///   - publisher: A **Publisher** instance.
    ///   - onFail: Transform publisher's failure into an ``Effect``
    ///   - onComplete: Transform publisher's completion into an ``Effect``
    ///   - action: Transform publisher's result into an ``Effect``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<P: Publisher>(_ publisher: P, receiveOn: DispatchQueue? = nil, onFail: Transformer<P.Failure, Effect>? = nil, onComplete: Transformer<Bool, Effect>? = nil, to effect: @escaping Transformer<P.Output, Effect>) -> AnyCancellable {
        publisher
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .finished:
                    if let onComplete = onComplete {
                        reduce(effect: onComplete(true))
                    }
                case let .failure(error):
                    if let onFail = onFail {
                        reduce(effect: onFail(error))
                    }
                }
            }, receiveValue: { output in
                reduce(effect: effect(output))
            })
    }
}

public extension EffectReducer where Self: ReducibleState {
    @discardableResult
    /// Receive state change from an observable object and transforms it to an ``Effect``
    /// - Parameters:
    ///   - feature: A conformance of ``MutableState`` and **ObservableObject**.
    ///   - action: Transform state of feature into an ``Effect``.
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState & ObservableObject>(_ feature: F, receiveOn: DispatchQueue? = nil, to effect: @escaping Transformer<F.State, Effect>) -> AnyCancellable {
        feature.statePublisher
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink {
                reduce(effect: effect($0))
            }
    }
}

/// ``EffectReducer`` extension of ``Processing``
public extension Processing where Self: EffectReducer {
    func effect(_ effect: Effect) {
        reduce(effect: effect)
    }
}

public extension EffectReducer where Self: Observer {
    /// Bind a combine publisher to an ``Effect``
    /// - Parameters:
    ///   - publisher: A **Publisher** instance.
    ///   - onFail: Transform publisher's failure into an ``Effect``
    ///   - onComplete: Transform publisher's completion into an ``Effect``
    ///   - action: Transform publisher's result into an ``Effect``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<P: Publisher>(_ publisher: P, receiveOn: DispatchQueue? = nil, onFail: Transformer<P.Failure, Effect>? = nil, onComplete: Transformer<Bool, Effect>? = nil, to effect: @escaping Transformer<P.Output, Effect>) {
        bind(publisher, receiveOn: receiveOn, onFail: onFail, onComplete: onComplete, to: effect).store(in: &cancellables)
    }
}

public extension EffectReducer where Self: ReducibleState & Observer {
    /// Receive state change from an observable object and transforms it to an ``Effect``
    /// - Parameters:
    ///   - feature: A conformance of ``MutableState`` and **ObservableObject**.
    ///   - action: Transform state of feature into an ``Effect``.
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState & ObservableObject>(_ feature: F, receiveOn: DispatchQueue? = nil, to effect: @escaping Transformer<F.State, Effect>) {
        bind(feature, receiveOn: receiveOn, to: effect).store(in: &cancellables)
    }
}
