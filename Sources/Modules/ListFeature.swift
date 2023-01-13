// ListFeature.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

public class ListFeature<Value>: Modulable {
    @FeatureModule(ValueFeature([])) public var items: [Value]
    @FeatureModule(ValueFeature(nil)) public var selectedItem: Value?

    public init(_ items: [Value]? = nil, selectedItem: Value? = nil) {
        self.items = items ?? []
        self.selectedItem = selectedItem
    }

    public var value: Property<[Value]> {
        Property(self, keyPath: \.items)
    }
}
