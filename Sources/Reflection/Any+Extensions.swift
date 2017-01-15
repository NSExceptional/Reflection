//
//  Any+Extensions.swift
//  Reflection
//
//  Created by Bradley Hilton on 10/17/16.
//
//

/// Any type can conform to this protocol via `extensions(of:)`
protocol AnyExtensions {}

extension AnyExtensions {
    
    static func construct(constructor: (Property.Description) throws -> Any) throws -> Any {
        return try Reflection.construct(self, constructor: constructor)
    }
    
    static func construct(dictionary: [String: Any]) throws -> Any {
        return try Reflection.construct(self, dictionary: dictionary)
    }
    
    static func isValueTypeOrSubtype(_ value: Any) -> Bool {
        return value is Self
    }
    
    static func value(from storage: UnsafeRawPointer) -> Any {
        return storage.assumingMemoryBound(to: self).pointee
    }
    
    static func write(_ value: Any, to storage: UnsafeMutableRawPointer) throws {
        guard let this = value as? Self else {
            throw ReflectionError.valueIsNotType(value: value, type: self)
        }
        storage.assumingMemoryBound(to: self).initialize(to: this)
    }
    
}


/// Make use of the `AnyExtensions` methods given any type.
func extensions(of type: Any.Type) -> AnyExtensions.Type {
    /// Sets the underlying type of `Extensions` to the given type,
    /// as to make any type temporarily conform to AnyExtensions.
    
    // Must be declared in this scope to be thread-safe
    struct Extensions: AnyExtensions {}
    var extensions: AnyExtensions.Type = Extensions.self
    withUnsafePointer(to: &extensions) { pointer in
        UnsafeMutableRawPointer(mutating: pointer).assumingMemoryBound(to: Any.Type.self).pointee = type
    }
    return extensions
}

/// Make use of the `AnyExtensions` methods given any value.
func extensions(of value: Any) -> AnyExtensions {
    /// Creates a temporary instance of `Extensions` and changes its type to the given type,
    /// as to make any instance of any type temporarily conform to AnyExtensions.
    
    // Must be declared in this scope to be thread-safe
    struct Extensions: AnyExtensions {}
    var extensions: AnyExtensions = Extensions()
    withUnsafePointer(to: &extensions) { pointer in
        UnsafeMutableRawPointer(mutating: pointer).assumingMemoryBound(to: Any.self).pointee = value
    }
    return extensions
}
