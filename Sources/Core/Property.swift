// Property.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation
import SwiftUI

/// Feature representation as a property. A property has a setter and getter function with the same type of a value.
public struct Property<Value> {
    public init(set: @escaping (Value) -> Void, get: @escaping () -> Value) {
        self.set = set
        self.get = get
    }

    public init<S: AnyObject>(_ target: S, keyPath: ReferenceWritableKeyPath<S, Value>) {
        set = { [target] in
            target[keyPath: keyPath] = $0
        }
        get = { [target] in
            target[keyPath: keyPath]
        }
    }

    let set: (Value) -> Void
    let get: () -> Value
}

public extension Property {
    func map(set: ((Value) -> Void)? = nil, get: (() -> Value)? = nil) -> Self {
        let s = self.set
        let g = self.get
        return .init(
            set: {
                if let set {
                    set($0)
                } else {
                    s($0)
                }
            },
            get: {
                if let get {
                    return get()
                } else {
                    return g()
                }
            }
        )
    }
}

public extension Property {
    /// Synthesized binding property from ``value: Property<Value?>``.
    var binding: Binding<Value> {
        Binding { [self] in
            get()
        } set: { [self] in
            set($0)
        }
    }
}

/// Feature representation as a property. A property has a setter and getter function with the same type of a value.
public struct OptionalProperty<Value> {
    public init(set: @escaping (Value?) -> Void, get: @escaping () -> Value?) {
        self.set = set
        self.get = get
    }

    let set: (Value?) -> Void
    let get: () -> Value?
}

public extension OptionalProperty {
    func modified(set: ((Value?) -> Void)? = nil, get: (() -> Value?)? = nil) -> Self {
        let s = self.set
        let g = self.get
        return .init(
            set: {
                if let set {
                    set($0)
                } else {
                    s($0)
                }
            },
            get: {
                if let get {
                    return get()
                } else {
                    return g()
                }
            }
        )
    }
}
