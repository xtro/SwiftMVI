// Binding.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine
import Foundation
import SwiftUI

public extension Binding {
    /// Synthesized binding for a modulable feature
    static func feature<M: Modulable>(_ feature: M) -> Binding<M.Value> {
        feature.binding
    }

    /// Synthesized binding for a modulable feature with optional value
    static func feature<M: OptionalModulable>(_ feature: M) -> Binding<M.Value?> {
        feature.value.binding
    }
}
