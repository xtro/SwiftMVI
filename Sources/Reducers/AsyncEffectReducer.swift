// AsyncEffectReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation

// MARK: Definition

public protocol AsyncEffectReducer {
    associatedtype Effect
    func reduce(effect: Effect) async
}

public extension Processing where Self: AsyncEffectReducer {
    /// Processing a given ``AsyncEffectReducer/Effect`` asynchroniously.
    /// - Parameter effect: An ``AsyncEffectReducer/Effect``
    func effect(_ effect: Effect) async {
        await reduce(effect: effect)
    }
}
