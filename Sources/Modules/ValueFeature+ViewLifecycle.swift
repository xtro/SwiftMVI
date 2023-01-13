// ValueFeature+ViewLifecycle.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import SwiftUI

public enum ViewState {
    case initialized
    case onAppear
    case onDisappear
}

private struct ViewLifecycleModifier: ViewModifier {
    let lifecycle: ValueFeature<ViewState>
    func body(content: Content) -> some View {
        content
            .onAppear {
                lifecycle(.update(.onAppear))
            }
            .onDisappear {
                lifecycle(.update(.onDisappear))
            }
    }
}

public extension View {
    func bind(lifecycle: ValueFeature<ViewState>) -> some View {
        modifier(
            ViewLifecycleModifier(lifecycle: lifecycle)
        )
    }
}
