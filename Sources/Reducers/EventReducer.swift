// EventReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

import Combine
import Foundation

/// Event reducer is a way to publish events.
public protocol EventReducer {
    associatedtype Event
    typealias Publisher = PassthroughSubject<Event, Never>
    var publisher: Publisher { get }
}

public extension Processing where Self: EventReducer {
    /// Publish an event
    /// - Parameter event: An event defined in ``EventReducer/Event``.
    func publish(_ event: Event) {
        publisher.send(event)
    }

    /// Publish a notification using given or default notification center.
    /// - Parameters:
    ///   - notification: A `Notification/Name`.
    ///   - object: Any object to post.
    func publish(_ notification: Notification.Name, object: Any? = nil, notificationCenter: NotificationCenter? = nil) {
        (notificationCenter ?? NotificationCenter.default).post(name: notification, object: object)
    }
}

public extension EventReducer where Self: ObservableObject {
    @discardableResult
    /// Bind a combine publisher to an ``Event``
    /// - Parameters:
    ///   - publisher: A **Publisher** instance.
    ///   - onFail: Transform publisher's failure into an ``Event``
    ///   - onComplete: Transform publisher's completion into an ``Event``
    ///   - action: Transform publisher's result into an ``Event``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<P: Combine.Publisher>(_ publisher: P, receiveOn: DispatchQueue? = nil, onFail: Transformer<P.Failure, Event>? = nil, onComplete: Transformer<Bool, Event>? = nil, to event: @escaping Transformer<P.Output, Event>) -> AnyCancellable {
        publisher
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] complete in
                switch complete {
                case .finished:
                    if let onComplete = onComplete {
                        self?.publisher.send(onComplete(true))
                    }
                case let .failure(error):
                    if let onFail = onFail {
                        self?.publisher.send(onFail(error))
                    }
                }
            }, receiveValue: { [weak self] output in
                self?.publisher.send(event(output))
            })
    }
}

public extension EventReducer where Self: ObservableObject {
    @discardableResult
    /// Receive state change from an observable object and transforms it to an ``Effect``
    /// - Parameters:
    ///   - feature: A conformance of ``ReducibleState`` and **ObservableObject**.
    ///   - action: Transform state of feature into an ``Effect``.
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState & ObservableObject>(_ feature: F, receiveOn: DispatchQueue? = nil, to event: @escaping Transformer<F.State, Event>) -> AnyCancellable {
        feature.objectWillChange
            .receive(on: receiveOn ?? DispatchQueue.main)
            .sink { [weak self] _ in
                self?.publisher.send(event(feature.state))
            }
    }
}

public extension EventReducer where Self: Observer {
    /// Bind a combine publisher to an ``Event``
    /// - Parameters:
    ///   - publisher: A **Publisher** instance.
    ///   - onFail: Transform publisher's failure into an ``Event``
    ///   - onComplete: Transform publisher's completion into an ``Event``
    ///   - action: Transform publisher's result into an ``Event``
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<P: Combine.Publisher>(_ publisher: P, receiveOn: DispatchQueue? = nil, onFail: Transformer<P.Failure, Event>? = nil, onComplete: Transformer<Bool, Event>? = nil, to event: @escaping Transformer<P.Output, Event>) {
        bind(publisher, receiveOn: receiveOn, onFail: onFail, onComplete: onComplete, to: event).store(in: &cancellables)
    }
}

public extension EventReducer where Self: Observer {
    /// Receive state change from an observable object and transforms it to an ``Event``
    /// - Parameters:
    ///   - feature: A conformance of ``ReducibleState`` and **ObservableObject**.
    ///   - action: Transform state of feature into an ``Event``.
    /// - Returns: A cancellable instance of **AnyCancellable**.
    func bind<F: ReducibleState & ObservableObject>(_ feature: F, receiveOn: DispatchQueue? = nil, to event: @escaping Transformer<F.State, Event>) {
        bind(feature, receiveOn: receiveOn, to: event).store(in: &cancellables)
    }
}
