// ImmutableReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

public protocol ImmutableReducer {
    associatedtype Intent
    associatedtype State
    func reduce(state: State, intent: Intent) throws -> State
}

public extension ImmutableReducer {
    func callAsFunction(_ state: State, _ intent: Intent) throws -> State {
        try reduce(state: state, intent: intent)
    }
}
