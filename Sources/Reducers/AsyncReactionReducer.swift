// AsyncReactionReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

/// Assyncronous reaction reducer is an extendend type of ``Action`` resulting a ``Reaction``
public protocol AsyncReactionReducer {
    associatedtype Action
    associatedtype Reaction
    func reduce(action: Action) async throws -> Reaction
}

// MARK: Processing

public extension Processing where Self: AsyncReactionReducer {
    /// Processing a given ``AsyncActionReducer/Action`` asynchroniously then returns a ``AsyncActionReducer/Reaction``.
    /// - Parameter action: An ``AsyncActionReducer/Action``
    /// - Returns: A ``AsyncActionReducer/Reaction``
    func action(_ action: Action) async throws -> Reaction {
        try await reduce(action: action)
    }
}
