//
//  File.swift
//  
//
//  Created by Gabor Nagy on 2023. 01. 15..
//

import SwiftUI

public extension NavigationLink {
    init<Wrapped, M: Modulable>(_ module: M, destination: () -> Destination, label: () -> Label) where M.Value == Wrapped? {
        self.init(isActive: module.binding.mappedToBool(), destination: destination, label: label)
    }
    init<Wrapped, Value, M: Modulable>(_ module: M, tag: Value, destination: () -> Destination) where M.Value == Wrapped?, M.Value: Hashable, Label == EmptyView, Value == Wrapped {
        self.init(destination: destination(), tag: tag, selection: module.binding, label: { EmptyView()})
    }
    init<Wrapped, M: Modulable>(_ module: M, destination: () -> Destination) where M.Value == Wrapped?, Label == EmptyView {
        self.init(isActive: module.binding.mappedToBool(), destination: destination, label: { EmptyView() })
    }
}
