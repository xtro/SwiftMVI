// ReducerComponent.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

import Combine
import SwiftUI

/// Reducer component is an implementation of reducer. A component is a simple class represents his own state and handle actions emiitted from other reducers.
public protocol ReducerComponent: ReducibleState, Observer {
    associatedtype Intent
    func reduce(intent: Intent) -> Bool
}

public extension ReducerComponent {
    func callAsFunction(_ intent: Intent) -> Bool {
        reduce(intent: intent)
    }
}

public extension ReducerComponent where Self: Observer {
    func callAsFunction(_ intent: Intent, update: Bool = true, animation: Animation? = nil) {
        if update, reduce(intent: intent) {
            if let animation = animation {
                withAnimation(animation) {
                    objectWillChange.send()
                }
            } else {
                objectWillChange.send()
            }
        }
    }
}
