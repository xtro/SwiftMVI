// AnyPath.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import CasePaths
import Foundation

public struct AnyPath<Root, Value> {
    private let keyPath: KeyPath<Root, Value>?
    private let casePath: CasePath<Root, Value>?

    public init(_ keyPath: KeyPath<Root, Value>) {
        self.keyPath = keyPath
        casePath = nil
    }

    public init(_ casePath: CasePath<Root, Value>) {
        keyPath = nil
        self.casePath = casePath
    }

    public func value(of input: Root) -> Value? {
        if let casePath {
            if let match = casePath.extract(from: input) {
                return match
            }
        } else if let keyPath {
            return input[keyPath: keyPath]
        }
        return nil
    }

    public static func keyPath(_ keyPath: KeyPath<Root, Value>) -> Self {
        AnyPath(keyPath)
    }

    public static func casePath(_ casePath: CasePath<Root, Value>) -> Self {
        AnyPath(casePath)
    }
}
