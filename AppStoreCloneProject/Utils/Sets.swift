//
//  Sets.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import Foundation
import CoreGraphics

public protocol Sets {}

extension Sets where Self: Any {
    public func with(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
    public func desc(_ block: () -> Void) {
        block()
    }
    
    public func `do`(_ block: (Self) -> Void) {
        block(self)
    }
    
    internal func to<T>(_ block: (inout Self) -> T) -> T {
        var copy = self
        return block(&copy)
    }
}

extension Sets where Self: AnyObject {
    public func Sets(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Sets {}
extension CGPoint: Sets {}
extension CGRect: Sets {}
extension CGSize: Sets {}
extension CGFloat: Sets {}
extension UIEdgeInsets: Sets {}
extension Date: Sets {}

extension String: Sets {}
extension Int: Sets {}
extension Bool: Sets {}
extension Array: Sets {}
extension Dictionary: Sets {}
