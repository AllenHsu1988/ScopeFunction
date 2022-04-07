//
//  ScopeFunction.swift
//  PhotoGrid
//
//  Created by Allen on 2022/3/10.
//  Copyright © 2022 CMCM. All rights reserved.
//

import Foundation


public protocol ScopeFunction {}

extension NSObject: ScopeFunction {}
extension Array: ScopeFunction {}
extension Dictionary: ScopeFunction {}
extension Set: ScopeFunction {}
extension String: ScopeFunction {}
extension Int: ScopeFunction {}
extension CGFloat: ScopeFunction {}
extension CGRect: ScopeFunction {}
extension Bool: ScopeFunction {}
extension Float: ScopeFunction {}
extension IndexPath: ScopeFunction {}

#if os(iOS) || os(tvOS)
extension UIEdgeInsets: ScopeFunction {}
extension UIOffset: ScopeFunction {}
extension UIRectEdge: ScopeFunction {}
#endif

/// Makes it available to execute something with closures.
///
///     let dic: Dictionary<String, String> = with("Allen") {
///       ["name" : $0]
///     }
@inlinable
public func withStruct<T: Any, V>(_ value: T, _ block: (inout T) throws -> V) rethrows -> V {
    var copy = value
    return try block(&copy)
}

/// Makes it available to execute something with closures.
///
///     let button: UIButton = UIButton()
///     with(button) {
///       $0.backgroundColor = UIColor.black
///     }
@inlinable
@discardableResult public func withObject<T: AnyObject, V>(_ value: T, _ block: (T) throws -> V) rethrows -> V {
    return try block(value)
}

extension ScopeFunction where Self: Any {

    /// Makes it available to execute something with closures.
    ///
    ///     let dic: Dictionary = "Allen".let {
    ///       ["name" : $0]
    ///     }
    @inlinable
    @discardableResult public func `let`<T>(_ block: (inout Self) throws -> T) rethrows -> T {
        var copy = self
        return try block(&copy)
    }

    /// Makes it available to set properties with closures just after initializing and copying the value types.
    ///
    ///     let rect = CGRect().also {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///       view.frame = $0
    ///     }
    @inlinable
    public func also(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }

    @inlinable
    public func takeIf(_ block: (inout Self) throws -> Bool) rethrows -> Self? {
        var copy = self
        return try block(&copy) ? copy : nil
    }

}

extension ScopeFunction where Self: AnyObject {

    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label: UILabel = GlobalSetting.share().userName.let {
    ///         let v = UILabel()
    ///         v.text = $0
    ///         return v
    ///     }
    @inlinable
    @discardableResult public func `let`<T>(_ block: (Self) throws -> T) rethrows -> T {
        return try block(self)
    }

    /// Makes it available to set properties with closures just after initializing and copying the value types.
    ///
    ///     launchOptions.also {
    ///         $0[UIApplication.LaunchOptionsKey.userActivityDictionary] = ["UIApplicationLaunchOptionsUserActivityKey" : userActivity]
    ///         $0[UIApplication.LaunchOptionsKey.userActivityType] = userActivity.activityType
    ///         $0[UIApplication.LaunchOptionsKey.url] = userActivity.webpageURL
    ///     }
    @inlinable
    @discardableResult public func also(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }

    @inlinable
    @discardableResult public func takeIf(_ block: (Self) throws -> Bool) rethrows -> Self? {
        return try block(self) ? self : nil
    }

}
