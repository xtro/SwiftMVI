// ListFeature.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

public class ListFeature<Value: Equatable>: Modulable {
    @FeatureModule(ValueFeature([])) public var items: [Value]
    @FeatureModule(ValueFeature(nil)) public var selectedItem: Value?

    public required init(value: [Value]) {
        self.items = value
        self.selectedItem = nil
    }
    public init() {
        self.items = []
        self.selectedItem = nil
    }

    public init(_ items: [Value], selectedItem: Value) {
        self.items = items
        self.selectedItem = selectedItem
    }

    public var value: Property<[Value]> {
        Property(self, keyPath: \.items)
    }
    
}
