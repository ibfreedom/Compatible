//
//  Compatible.swift
//  Compatible
//
//  Created by tramp on 2021/4/1.
//

import Foundation

/// CompatibleWapper
public struct CompatibleWapper<Base> {
    /// Base
    public let base: Base
    
    /// 构建
    /// - Parameter base: Base
    public init(with base: Base) {
        self.base = base
    }
}

/// Compatible
public protocol Compatible: AnyObject {}
extension Compatible {
    
    /// CompatibleWapper<Self>
    public var hub: CompatibleWapper<Self> {
        return .init(with: self)
    }
}

/// CompatibleValue
public protocol CompatiableValue {}
extension CompatiableValue {
    
    /// CompatibleWapper<Self>
    public var hub: CompatibleWapper<Self> {
        return .init(with: self)
    }
}

