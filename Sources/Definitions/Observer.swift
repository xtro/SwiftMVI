// Observer.swift
//
// Copyright (c) 2022-2023 Gabor Nagy
// Created by gabor.nagy.0814@gmail.com on 2022. 12. 30..

import Combine
import Foundation
import SwiftUI

open class Observer: ObservableObject, Observable {
    public var cancellables: Set<AnyCancellable> = []
    public init() {}
}

public extension Observer {
    final func bind<T: ObservableObject>(_ children: T..., animation: Animation? = nil) {
        children.forEach {
            bind($0, animation: animation)
        }
    }

    func bind<T: ObservableObject>(_ child: T, animation: Animation? = nil) {
        child.objectWillChange.sink { [weak self] _ in
            if let animation = animation {
                withAnimation(animation) {
                    self?.objectWillChange.send()
                }
            } else {
                self?.objectWillChange.send()
            }
        }.store(in: &cancellables)
    }

    final func overlookChildren() {
        cancellables.removeAll()
    }
}
