//
//  NSLock+Hub.swift
//  Compatible
//
//  Created by tramp on 2021/4/1.
//

#if canImport(Foundation) && !os(Linux)
import Foundation

extension NSLock: Compatible {}
extension CompatibleWapper where Base: NSLock {
    
    /// execute block
    /// - Parameter block: @escaping () -> Void
    public func execute(_ block: @escaping () -> Void) {
        base.lock()
        block()
        base.unlock()
    }
    
    /// execute
    /// - Parameter block: @escaping () -> T
    /// - Returns: T
    @discardableResult
    public func execute<T>(_ block: @escaping () -> T) -> T {
        base.lock()
        let value = block()
        base.unlock()
        return value
    }
}

#endif
