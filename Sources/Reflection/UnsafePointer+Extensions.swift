//
//  UnsafePointer+Extensions.swift
//  Reflection
//
//  Created by Bradley Hilton on 10/29/16.
//
//

extension UnsafePointer {
    
    /// "Casts" an `UnsafePointer` between `Pointee` types.
    init<T>(_ pointer: UnsafePointer<T>) {
        self = UnsafeRawPointer(pointer).assumingMemoryBound(to: Pointee.self)
    }
    
}
