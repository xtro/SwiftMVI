// ReactionReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

/// Reaction reducer is an extendend type of ``Action`` resulting a ``Reaction``
public protocol ReactionReducer {
    associatedtype Action
    associatedtype Reaction
    func reduce(action: Action) throws -> Reaction
}

/// ``ReactionReducer`` extension of ``Processing``
public extension Processing where Self: ReactionReducer {
    /// Action reducer
    /// - Parameter action: ``ReactionReducer/Action`` to reduce.
    /// - Returns: A ``ReactionReducer/Reaction``
    func action(_ action: Action) throws -> Reaction {
        try reduce(action: action)
    }
}
