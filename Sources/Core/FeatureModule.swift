// FeatureModule.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Foundation
import SwiftUI

@propertyWrapper
public struct FeatureModule<Feature: Modulable, Value> where Value == Feature.Value {
    public var wrappedValue: Value {
        get {
            feature.value.get()
        }
        set {
            feature.value.set(newValue)
        }
    }

    public var projectedValue: Feature {
        feature
    }

    public typealias Map = KeyPath<Feature, Property<Value>>
    private var map: Map
    public var feature: Feature
}

public extension FeatureModule where Feature: ReducibleState {
    var publisher: Feature.StatePublisher {
        feature.statePublisher
    }
}

public extension FeatureModule {
    init(_ feature: Feature) where Value == Feature.Value {
        self.feature = feature
        map = \Feature.value
    }

    init(_ feature: Feature, map: Map) {
        self.feature = feature
        self.map = map
    }
}
