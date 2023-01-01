// AsyncActionReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

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
