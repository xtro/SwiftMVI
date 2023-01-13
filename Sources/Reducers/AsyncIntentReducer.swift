// AsyncIntentReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Foundation

/// Intent reducer is a user intent to do something.
public protocol AsyncIntentReducer {
    /// A representation of user’s intents that typically changes the ``MutableState`` or emits an ``EventReducer/Event``
    associatedtype Intent
    func reduce(intent: Intent) async
}

public extension AsyncIntentReducer {
    @discardableResult
    func callAsFunction(_ intent: Intent, priority: TaskPriority? = nil) -> Task<Void, Never> {
        Task.detached(priority: priority) { [self] in
            await reduce(intent: intent)
        }
    }
}

public extension Processing where Self: AsyncIntentReducer {
    /// Processing an ``AsyncIntentReducer/Intent`` asynchroniously.
    /// - Parameter intent: An ``AsyncIntentReducer/Intent``
    func intent(_ intent: Intent) async {
        await reduce(intent: intent)
    }
}
