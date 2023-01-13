// PublishedPathView.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import CasePaths
import Combine
import SwiftUI

struct PublishedPathView<Content: View, Reducer, Reducible, Reduced, P: Publisher, Value>: View where P.Failure == Never, P.Output == Reducible {
    @State private var currentValue: Value?
    private let reducer: Reducer
    private let map: @Sendable (Reducible) -> Reduced
    private let publisher: P
    private let path: AnyPath<Reduced, Value>
    private let content: (Value) -> Content
    private let persistent: Bool

    init(_ reducer: Reducer, persistent: Bool = false, map: @Sendable @escaping (Reducible) -> Reduced, publisher: P, path: AnyPath<Reduced, Value>, @ViewBuilder content: @escaping (Value) -> Content) {
        self.reducer = reducer
        self.map = map
        self.path = path
        self.content = content
        self.publisher = publisher
        self.persistent = persistent
    }

    var body: some View {
        Group {
            if let value = currentValue {
                content(value)
            }
        }
        .onReceive(publisher.receive(on: DispatchQueue.main)) { event in
            if persistent {
                if currentValue == nil {
                    currentValue = path.value(of: map(event))
                }
            } else {
                currentValue = path.value(of: map(event))
            }
        }
    }
}
