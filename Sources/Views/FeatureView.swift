// FeatureView.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import SwiftUI

public protocol FeatureView: View {
    associatedtype ReducerType: ReducibleState
    associatedtype ReducedView: View
    associatedtype Value
    func body(_ state: Value) -> ReducedView
    var feature: ReducerType { get }
    var path: AnyPath<ReducerType.State, Value> { get }
}

public extension FeatureView {
    var body: some View {
        StateReducerView(feature, path) {
            body($0)
        }
    }
}

public extension FeatureView where Value == ReducerType.State {
    var path: AnyPath<ReducerType.State, Value> {
        .init(\.self)
    }
}
