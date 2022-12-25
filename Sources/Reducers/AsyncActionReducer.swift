// AsyncActionReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

/// **AsyncActionReducer** is a special types of action reducers. It can returns a Reaction or throws an error.
public protocol AsyncActionReducer {
    /// An action.
    associatedtype Action
    /// A reaction.
    associatedtype Reaction
    /// Async action reducer
    /// - Parameter action: ``Action`` to reduce.
    /// - Returns: a ``Reaction``
    func reduce(action: Action) async throws -> Reaction
}

public extension Processing where Self: AsyncActionReducer {
    /// Processing a given ``AsyncActionReducer/Action`` asynchroniously.
    /// - Parameter action: An ``AsyncActionReducer/Action``.
    /// - Returns: A ``AsyncActionReducer/Reaction``.
    func action(_ action: Action) async throws -> Reaction {
        try await reduce(action: action)
    }
}
