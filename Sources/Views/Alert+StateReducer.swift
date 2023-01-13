// Alert+StateReducer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import CasePaths
import Combine
import Foundation
import SwiftUI
import SwiftUseCase

private struct AlertStateReducerModifier<R: ReducibleState & Modulable>: ViewModifier where R.State == Alert?, R.State == R.Value {
    @State private var isPresented: Bool = false
    @State private var model: Alert? = nil

    private let reducer: R

    init(_ reducer: R) {
        self.reducer = reducer
    }

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                reducer.state!
            }
            .onReceive(reducer.statePublisher) {
                isPresented = $0 != nil
            }
    }
}

public extension View {
    func alert<R: ReducibleState & Modulable>(_ reducer: R) -> some View where R.State == Alert?, R.Value == Alert? {
        modifier(
            AlertStateReducerModifier(reducer)
        )
    }
}
