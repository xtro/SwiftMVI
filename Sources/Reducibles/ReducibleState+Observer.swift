// ReducibleState+Observer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 23..

import SwiftUI

/// Processing a ``ReducableState`` of an ``Observer``
@MainActor public extension Processing where Self: ReducibleState, Self: Observer {
    func state(update: Bool = true, animation: Animation? = nil, block: @escaping (State) -> Void) {
        block(state)
        if update {
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
