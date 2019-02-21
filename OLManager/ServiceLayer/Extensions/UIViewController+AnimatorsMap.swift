//
//  UIViewController+OverlaysMap.swift
//  OLManager
//
//  Created by Максим Остапчук on 2/21/19.
//

import Foundation

extension UIViewController: PropertyStoring {
    typealias T = [AnimationPerformer]
    
    private struct AssociatedKeys {
        static var performersKey = "UIViewController.AnimationPerformers"
    }
    
    var animationPerformers: [AnimationPerformer] {
        get {
            return getAssociatedObject(AssociatedKeys.performersKey, defaultValue: [])
        }
        set (performers) {
            objc_setAssociatedObject(self, &AssociatedKeys.performersKey, performers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
