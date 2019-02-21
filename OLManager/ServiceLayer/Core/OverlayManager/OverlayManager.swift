//
//  OverlayManager.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/23/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

public protocol OverlayManager {
    
    associatedtype OverlayFactoryImp: OverlayFactory
    
    func addOverlayWindowWithFrame(_ frame: CGRect, level: UIWindow.Level)
    
    func displayOverlay(_ overlay: OverlayFactoryImp.OverlayType, configuration: OverlayDisplayConfiguration) -> OverlayManageable?
    
    func hideOverlays(level: OverlayLevel, animated: Bool)
    
    func displayExistedOverlays(level: OverlayLevel)
    
    init(factory: OverlayFactoryImp)
}

public final class OverlayManagerOf<OverlayFactoryImp: OverlayFactory>: OverlayManager {
 
    private let animationPerformerFactory: AnimationPerformerFactory
    private var overlaysFactory: OverlayFactoryImp
    
    private var globalAnimatorsMap: [AnimationPerformer]
    
    private var overlayWindow: OverlayWindow?
    private var currentViewController: UIViewController?
    private var currentAnimatorContainer: [AnimationPerformer] {
        get {
            if let box = currentViewController?.animationPerformers {
                return box
            }
            return []
        }
        set {
            currentViewController?.animationPerformers = newValue
        }
    }
    
    public init(factory: OverlayFactoryImp) {
        animationPerformerFactory = AnimationPerformerFactoryImp()
        globalAnimatorsMap = [AnimationPerformer]()
        overlaysFactory = factory
    }
}

// MARK: - OverlayManager
public extension OverlayManagerOf {

    func addOverlayWindowWithFrame(_ frame: CGRect, level: UIWindow.Level) {
        let window = OverlayWindow(frame: frame)
        window.windowLevel = level + 1
        window.rootViewController = OverlayWindowRootViewController()
        window.isHidden = false
        
        overlayWindow = window
    }
    
    func displayOverlay(_ overlay: OverlayFactoryImp.OverlayType, configuration: OverlayDisplayConfiguration) -> OverlayManageable? {
        
        guard
            let rootVC = overlayWindow?.overlayViewController,
            let currentVC = currentViewController else {
                assertionFailure()
                return nil
        }
        
        let overlayView = overlaysFactory.makeOverlayWith(type: overlay)
        let animator = animationPerformerFactory.makeAnimationPerformerFor(overlayView, with: configuration.animationType, windowRootViewController: rootVC, overlayedViewController: currentVC, displayConfig: configuration)
        
        let collection = getCollectionForLevel(configuration.overlayLevel)
        collection.pointee.append(animator)
        
        animator.displayOverlay()
        
        return OverlayManageableImp(overlay: overlayView, overlayManageble: self)
    }
    
    func hideOverlays(level: OverlayLevel, animated: Bool) {
        let collection = getCollectionForLevel(level)
        
        for animator in collection.pointee {
            animator.removeOverlay(animated: animated, completion: nil)
        }
    }
    
    func displayExistedOverlays(level: OverlayLevel) {
        let collection = getCollectionForLevel(level)
        
        for animator in collection.pointee {
            animator.displayOverlayWithoutAnimation()
        }
    }
}

// MARK: - PrivateHelpers
private extension OverlayManagerOf {
    
    private func getAnimatorFor(_ overlay: UIView) -> AnimationPerformer? {
        let neededContainerArray = currentAnimatorContainer.filter({ return $0.overlay == overlay })
        return neededContainerArray.first
    }
    
    private func getCollectionForLevel(_ level: OverlayLevel) -> UnsafeMutablePointer<[AnimationPerformer]> {
        switch level {
        case .local:
            return withUnsafeMutablePointer(to: &currentAnimatorContainer, { $0 })
        case .global:
            return withUnsafeMutablePointer(to: &globalAnimatorsMap, { $0 })
        }
    }
}

// MARK: - OverlayRemovable
extension OverlayManagerOf: OverlayManageableConnection {

    internal func removeOverlay(_ overlay: UIView, animated: Bool) {
        guard let animator = getAnimatorFor(overlay) else {
            return
        }
        animator.removeOverlay(animated: animated) { [weak self] in
            guard let strongSelf = self else { return }
            // TODO: need to do it in another way
            strongSelf.globalAnimatorsMap = strongSelf.globalAnimatorsMap.filter({ return $0.overlay != overlay })
            strongSelf.currentAnimatorContainer = strongSelf.currentAnimatorContainer.filter({ return $0.overlay != overlay })
        }
    }
    
    internal func hideOverlay(_ overlay: UIView, animated: Bool) {
        guard let animator = getAnimatorFor(overlay) else {
            return
        }
        animator.removeOverlay(animated: animated, completion: nil)
    }
    
    internal func showOverlay(_ overlay: UIView, animated: Bool) {
        guard let animator = getAnimatorFor(overlay) else {
            return
        }
        if animated {
            animator.displayOverlay()
        } else {
            animator.displayOverlayWithoutAnimation()
        }
    }
}

// MARK: - ViewControllerObservable
extension OverlayManagerOf: ViewControllerObservable {
    
    public func viewControllerBecomeActive(_ viewController: UIViewController) {
        self.currentViewController = viewController
        displayExistedOverlays(level: .local)
    }
}
