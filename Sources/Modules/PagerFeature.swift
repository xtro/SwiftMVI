// ValueFeature.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2023. 01. 13.

import SwiftUI

public class PagerFeature: ReducibleState {
    public struct State: Hashable {
        public init(currentPage: Int, maxPages: Int, itemsPerPage: Int) {
            self.currentPage = currentPage
            self.maxPages = maxPages
            self.itemsPerPage = itemsPerPage
        }
        
        public init() {
            self.currentPage = 0
            self.maxPages = 0
            self.itemsPerPage = 0
        }
        
        public var currentPage: Int
        public let maxPages: Int
        public let itemsPerPage: Int
    }
    @Observed public var state: State

    public required init(value: State) {
        _state = Observed(wrappedValue: value)
    }
    public init() {
        _state = Observed(wrappedValue: State())
    }
}

extension PagerFeature: IntentReducer & Processing {
    public enum Intent {
        case update(by: Int)
    }

    public func reduce(intent: Intent) {
        switch intent {
        case .update(let newValue):
            let calculatedPage = Int(newValue/state.itemsPerPage)+1
            if state.currentPage < calculatedPage {
                state {
                    $0.currentPage += 1
                }
            }
        }
    }
}

extension PagerFeature: Modulable {
    public var value: Property<State> {
        Property(
            set: { [self] in
                self.state = $0
            },
            get: { [self] in
                state
            }
        )
    }
}
