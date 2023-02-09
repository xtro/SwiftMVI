//
//  Observed2.swift
//  
//
//  Created by Gabor Nagy on 2023. 02. 02..
//

import Foundation
import Combine

@propertyWrapper
public struct ObservedPassthrough<Value> {
    public typealias Subject = PassthroughSubject<Value, Never>
    @propertyWrapper
    private final class ReferenceStorage {
        var wrappedValue: Subject
        
        init(wrappedValue: Subject) {
            self.wrappedValue = wrappedValue
        }
    }
    
    @ReferenceStorage private var storage: Subject
    /// Creates the published instance with an initial wrapped value.
    ///
    /// Don't use this initializer directly. Instead, create a property with
    /// the `@Observed2` attribute, as shown here:
    ///
    ///     @Observed2 var lastUpdated: Subject
    ///
    /// - Parameter wrappedValue: The subject's initial value.
    public init() {
        storage = Subject()
    }
    public var wrappedValue: Subject {
        get {
            return storage
        }
        set {
            storage = newValue
        }
    }
    internal static func firstObserved<Target, Value>(on target: Target, value: Value) -> ObservedPassthrough<Value>.Subject? {
        var installedPublisher: ObservedPassthrough<Value>.Subject?
        var reflection: Mirror? = Mirror(reflecting: target)
        while let aClass = reflection {
            for (_, property) in reflection!.children {
                guard let property = property as? ObservedPassthrough<Value> else {
                    // Visit other fields until we meet a @Observed2 var xxx: State field
                    continue
                }
                installedPublisher = property.wrappedValue

            }
            reflection = aClass.superclassMirror
        }
        return installedPublisher
    }
}
