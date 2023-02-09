// ValueFeature.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import SwiftUI

public class ValueFeature<Value>: ReducibleState {
    public typealias State = Value
    @Observed public var state: State

    public required init(_ state: State) {
        _state = Observed(wrappedValue: state)
    }
    public required init(value: Value) where Value == State {
        state = value
    }
}

extension ValueFeature: IntentReducer & Processing {
    public enum Intent {
        case update(State)
    }

    public func reduce(intent: Intent) {
        switch intent {
        case let .update(newState):
            state {
                newState
            }
        }
    }
}

extension ValueFeature: Modulable {
    public var value: Property<Value> {
        Property(
            set: { [self] in
                self(.update($0))
            },
            get: { [self] in
                return state
            }
        )
    }
}
