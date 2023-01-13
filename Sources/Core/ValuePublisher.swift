// ValuePublisher.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import Combine

@propertyWrapper
public struct ValuePublisher<Value> {
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        publisher = Publisher()
    }

    public var wrappedValue: Value
    public typealias Publisher = PassthroughSubject<Value, Never>
    public var publisher: Publisher
}
