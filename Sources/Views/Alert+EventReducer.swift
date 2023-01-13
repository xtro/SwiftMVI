// Alert+EventReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import CasePaths
import Combine
import Foundation
import SwiftUI
import SwiftUseCase

private struct AlertEventReducerModifier<R: EventReducer, Value>: ViewModifier {
    @State private var isPresented: Bool = false
    @State private var currentValue: Alert? = nil

    private let reducer: R
    private let path: AnyPath<R.Event, Value>
    private let transform: (Value) -> Alert
    private let persistent: Bool

    init(_ reducer: R, _ keyPath: KeyPath<R.Event, Value>, persistent: Bool = false, @ViewBuilder map: @escaping (Value) -> Alert) {
        let path = AnyPath(keyPath)
        self.reducer = reducer
        self.path = path
        transform = map
        self.persistent = persistent
    }

    init(_ reducer: R, _ casePath: CasePath<R.Event, Value>, persistent: Bool = false, @ViewBuilder map: @escaping (Value) -> Alert) {
        let path = AnyPath(casePath)
        self.reducer = reducer
        self.path = path
        transform = map
        self.persistent = persistent
    }

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                currentValue!
            }
            .onReceive(reducer.publisher) { value in
                if persistent {
                    if currentValue == nil {
                        currentValue = path.value(of: value).map(transform)
                        isPresented = (currentValue != nil)
                        return
                    }
                }
                currentValue = path.value(of: value).map(transform)
                isPresented = (currentValue != nil)
            }
    }
}

public extension View {
    func alert<R: EventReducer, V>(_ reducer: R, _ onEvent: CasePath<R.Event, V>, persistent: Bool = false, map: @escaping (V) -> Alert) -> some View {
        modifier(
            AlertEventReducerModifier(
                reducer,
                onEvent,
                persistent: persistent,
                map: map
            )
        )
    }

    func alert<R: EventReducer, V>(_ reducer: R, _ onEvent: KeyPath<R.Event, V>, persistent: Bool = false, map: @escaping (V) -> Alert) -> some View {
        modifier(
            AlertEventReducerModifier(
                reducer,
                onEvent,
                persistent: persistent,
                map: map
            )
        )
    }
}
