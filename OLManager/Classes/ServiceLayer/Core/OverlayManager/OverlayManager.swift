//
//  OverlayManager.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/23/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

private typealias BaseVCBox = WeakBox<UIViewController>
private typealias OverlayContainer = (overlay: UIView, animator: AnimationPerformer)

public protocol OverlayManager {
    
    associatedtype OverlayFactoryImp: OverlayFactory
    
    func addOverlayWindowWithFrame(_ frame: CGRect, level: UIWindow.Level)
    
    func displayOverlay(_ overlay: OverlayFactoryImp.OverlayType, configuration: OverlayDisplayConfiguration) -> OverlayManageable?
    
    func hideOverlays(animated: Bool)
    
    func displayExistedOverlays()
    
    init(factory: OverlayFactoryImp)
}

public final class OverlayManagerOf<OverlayFactoryImp: OverlayFactory>: OverlayManager {
 
    private let animationPerformerFactory: AnimationPerformerFactory
    private var overlaysFactory: OverlayFactoryImp
    
    private var map: [BaseVCBox: [OverlayContainer]]
    
    private var overlayWindow: OverlayWindow?
    private var currentViewController: UIViewController?
    private var currentViewControllerBox: BaseVCBox? {
        if let viewController = currentViewController {
            return WeakBox.init(viewController)
        } else {
            return nil
        }
    }
    private var currentOverlayContainers: [OverlayContainer] {
        get {
            if let box = currentViewControllerBox, let currentContainers = map[box] {
                return currentContainers
            }
            return []
        }
        set {
            if let box = currentViewControllerBox {
                map.updateValue(newValue, forKey: box)
            }
        }
    }
    
    public init(factory: OverlayFactoryImp) {
        animationPerformerFactory = AnimationPerformerFactoryImp()
        map = [BaseVCBox: [OverlayContainer]]()
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
        let container = OverlayContainer(overlay: overlayView, animator: animator)
        
        var existedOverlays = currentOverlayContainers
        existedOverlays.append(container)
        currentOverlayContainers = existedOverlays
        
        removeZombiesOverlays()
        animator.displayOverlay()
        
        return OverlayManageableImp(overlay: overlayView, overlayManageble: self)
    }
    
    func hideOverlays(animated: Bool) {
        for container in currentOverlayContainers {
            container.animator.removeOverlay(animated: animated, completion: nil)
        }
    }
    
    func displayExistedOverlays() {
        for container in currentOverlayContainers {
            container.animator.displayOverlayWithoutAnimation()
        }
    }
}

// MARK: - PrivateHelpers
private extension OverlayManagerOf {

    func removeZombiesOverlays() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.map = strongSelf.map.filter({ return $0.key.item != nil })
        }
    }
    
    private func getContainerFor(_ overlay: UIView) -> OverlayContainer? {
        let neededContainerArray = currentOverlayContainers.filter({ return $0.overlay == overlay })
        return neededContainerArray.first
    }
}

// MARK: - OverlayRemovable
extension OverlayManagerOf: OverlayManageableConnection {

    internal func removeOverlay(_ overlay: UIView, animated: Bool) {
        guard let container = getContainerFor(overlay) else {
            return
        }
        container.animator.removeOverlay(animated: animated) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.currentOverlayContainers = strongSelf.currentOverlayContainers.filter({ return $0.overlay != overlay })
            strongSelf.removeZombiesOverlays()
        }
    }
    
    internal func hideOverlay(_ overlay: UIView, animated: Bool) {
        guard let container = getContainerFor(overlay) else {
            return
        }
        container.animator.removeOverlay(animated: animated, completion: nil)
    }
    
    internal func showOverlay(_ overlay: UIView, animated: Bool) {
        guard let container = getContainerFor(overlay) else {
            return
        }
        if animated {
            container.animator.displayOverlay()
        } else {
            container.animator.displayOverlayWithoutAnimation()
        }
    }
}

// MARK: - ViewControllerObservable
extension OverlayManagerOf: ViewControllerObservable {
    
    public func viewControllerBecomeActive(_ viewController: UIViewController) {
        self.currentViewController = viewController
        displayExistedOverlays()
        removeZombiesOverlays()
    }
}
