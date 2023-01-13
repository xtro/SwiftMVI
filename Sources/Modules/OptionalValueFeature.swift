// OptionalValueFeature.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Foundation
import SwiftUI

public class OptionalValueFeature<Value: Equatable>: IntentReducer & Processing & OptionalReducibleState {
    public typealias State = Value
    public var state: State?
    public var statePublisher = StatePublisher()

    public enum Intent {
        case update(State?)
    }

    public func reduce(intent: Intent) {
        switch intent {
        case let .update(newState):
            if newState != state {
                state {
                    newState
                }
            }
        }
    }

    public required init(_ state: State? = nil) {
        self.state = state
    }
}

extension OptionalValueFeature: Modulable {
    public var value: Property<Value?> {
        Property(
            set: { [self] in
                self(.update($0))
            },
            get: { [self] in
                state
            }
        )
    }
}
