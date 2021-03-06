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
    
    func displayExistedOverlays(level: OverlayLevel)
    
    init(factory: OverlayFactoryImp)
}

public final class OverlayManagerOf<OverlayFactoryImp: OverlayFactory>: OverlayManager {
 
    private let animationPerformerFactory: AnimationPerformerFactory
    private var overlaysFactory: OverlayFactoryImp
    
    private var globalAnimatorsContainer: [AnimationPerformer]
    
    private var overlayWindow: OverlayWindow?
    private weak var currentViewController: UIViewController?
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
        globalAnimatorsContainer = [AnimationPerformer]()
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
        
        guard let rootVC = overlayWindow?.overlayViewController else {
            return nil
        }
        
        let overlayView = overlaysFactory.makeOverlayWith(type: overlay)
        let animator = animationPerformerFactory.makeAnimationPerformerFor(overlayView, with: overlay.level, windowRootViewController: rootVC, displayConfig: configuration)
        
        switch overlay.level {
        case .local:
            currentAnimatorContainer.append(animator)
        case .global:
            globalAnimatorsContainer.append(animator)
        }
        
        animator.displayOverlay()
        
        return OverlayManageableImp(overlay: overlayView, overlayManageble: self)
    }
    
    func displayExistedOverlays(level: OverlayLevel) {
        let collection = getCollectionForLevel(level)
        
        for animator in collection {
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
    
    private func getCollectionForLevel(_ level: OverlayLevel) -> [AnimationPerformer] {
        switch level {
        case .local:
            return currentAnimatorContainer
        case .global:
            return globalAnimatorsContainer
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
            strongSelf.globalAnimatorsContainer = strongSelf.globalAnimatorsContainer.filter({ return $0.overlay != overlay })
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
        self.overlayWindow?.applyAvailableRegionsWith(viewController: viewController)
        
        displayExistedOverlays(level: .local)
    }
}
