// StateReducerView.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import CasePaths
import Combine
import SwiftUI

public struct StateReducerView<Content: View, Reducer: ReducibleState, Value>: View {
    private let reducer: Reducer
    private let path: AnyPath<Reducer.State, Value>
    private let content: (Value) -> Content
    private let persistent: Bool

    public init(_ reducer: Reducer, _ path: AnyPath<Reducer.State, Value>, persistent: Bool = false, @ViewBuilder content: @escaping (Value) -> Content) {
        self.reducer = reducer
        self.path = path
        self.content = content
        self.persistent = persistent
    }

    public init(_ reducer: Reducer, _ keyPath: KeyPath<Reducer.State, Value>, persistent: Bool = false, @ViewBuilder content: @escaping (Value) -> Content) {
        self.reducer = reducer
        path = AnyPath(keyPath)
        self.content = content
        self.persistent = persistent
    }

    public init(_ reducer: Reducer, _ casePath: CasePath<Reducer.State, Value>, persistent: Bool = false, @ViewBuilder content: @escaping (Value) -> Content) {
        self.reducer = reducer
        path = AnyPath(casePath)
        self.content = content
        self.persistent = persistent
    }

    public init(_ reducer: Reducer, persistent: Bool = false, @ViewBuilder content: @escaping (Value) -> Content) where Reducer.State == Value {
        self.reducer = reducer
        path = AnyPath(\.self)
        self.content = content
        self.persistent = persistent
    }

    public var body: some View {
        PublishedPathView(reducer, persistent: persistent, map: { _ in reducer.state }, publisher: reducer.statePublisher, path: path, content: content)
    }
}
