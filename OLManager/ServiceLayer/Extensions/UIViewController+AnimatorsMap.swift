//
//  UIViewController+OverlaysMap.swift
//  OLManager
//
//  Created by Максим Остапчук on 2/21/19.
//

import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var performersKey = "UIViewController.AnimationPerformers"
    }
    
    var animationPerformers: [AnimationPerformer] {
        get {
            let collection = objc_getAssociatedObject(self, &AssociatedKeys.performersKey) as? [AnimationPerformer]
            return collection ?? []
        }
        set (performers) {
            objc_setAssociatedObject(self, &AssociatedKeys.performersKey, performers, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
