// Modulable.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation
import SwiftUI

/// Modulable is a protocol for implementing feature modules
public protocol Modulable {
    associatedtype Value
    var value: Property<Value> { get }
}

public extension Modulable {
    /// Synthesized binding property from ``value: Property<Value>``.
    var binding: Binding<Value> {
        Binding { [self] in
            value.get()
        } set: { [self] in
            value.set($0)
        }
    }
}

/// Modulable is a protocol for implementing feature modules
public protocol OptionalModulable {
    associatedtype Value
    var value: Property<Value?> { get }
}

public extension Modulable where Self: ReducibleState, State == Value {
    var boolValue: Property<Bool> {
        .init(
            set: { _ in
            },
            get: { [self] in
                state != nil
            }
        )
    }

    var hasValue: Bool {
        boolValue.get()
    }
}
