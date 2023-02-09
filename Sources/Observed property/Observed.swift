//
//  Observed.swift
//  
//
//  Created by Gabor Nagy on 2023. 02. 02..
//

import Foundation
import Combine

@propertyWrapper
public struct Observed<Value> {
    public typealias Subject = CurrentValueSubject<Value, Never>
    private enum Storage {
        case value(Value)
        case subject(Subject)
    }
    @propertyWrapper
    private final class ReferenceStorage {
        var wrappedValue: Storage
        
        init(wrappedValue: Storage) {
            self.wrappedValue = wrappedValue
        }
    }
    
    @ReferenceStorage private var storage: Storage
    /// Creates the published instance with an initial wrapped value.
    ///
    /// Don't use this initializer directly. Instead, create a property with
    /// the `@Observed` attribute, as shown here:
    ///
    ///     @Observed var lastUpdated: Date = Date()
    ///
    /// - Parameter wrappedValue: The subject's initial value.
    public init(initialValue: Value) {
        self.init(wrappedValue: initialValue)
    }
    
    /// Creates the published instance with an initial value.
    ///
    /// Don't use this initializer directly. Instead, create a property with
    /// the `@Observed` attribute, as shown here:
    ///
    ///     @Observed var state: MyState = MyState()
    ///
    /// - Parameter initialValue: The subject's initial value.
    public init(wrappedValue: Value) {
        _storage = ReferenceStorage(wrappedValue: .value(wrappedValue))
    }
    
    public var projectedValue: Subject {
        get {
            switch storage {
            case .value(let value):
                let subject = Subject(value)
                storage = .subject(subject)
                return subject
            case .subject(let subject):
                return subject
            }
        }
        set {
        }
    }
    public var wrappedValue: Value {
        get {
            switch storage {
            case .value(let value):
                return value
            case .subject(let subject):
                return subject.value
            }
        }
        set {
            switch storage {
            case .value(_):
                storage = .value(newValue)
            case .subject(let subject):
                subject.send(newValue)
            }
        }
    }
    internal static func firstObserved<Target, Value>(on target: Target, value: Value) -> Observed<Value>.Subject? {
        var installedPublisher: Observed<Value>.Subject?
        var reflection: Mirror? = Mirror(reflecting: target)
        while let aClass = reflection {
            for (_, property) in reflection!.children {
                guard let property = property as? Observed<Value> else {
                    // Visit other fields until we meet a `@Observed var key: Value` field
                    continue
                }
                installedPublisher = property.projectedValue
                
            }
            reflection = aClass.superclassMirror
        }
        return installedPublisher
    }
}
