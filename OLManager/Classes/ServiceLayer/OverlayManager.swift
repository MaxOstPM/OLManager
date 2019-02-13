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
    
    func displayOverlay(_ overlay: OverlayFactoryImp.OverlayType, configuration: OverlayDisplayConfiguration) -> DisplayedOverlayRemover?
    
    func addOverlayWindowWithFrame(_ frame: CGRect, level: UIWindow.Level)

    func hideOverlays(animated: Bool)
    
    init(factory: OverlayFactoryImp)
}

public final class OverlayManagerOf<OverlayFactoryImp: OverlayFactory>: OverlayManager {
 
    private let animationPerformerFactory: AnimationPerformerFactory
    private var overlaysFactory: OverlayFactoryImp
    
    private var map: [BaseVCBox: [OverlayContainer]]
    
    private var overlayWindow: OverlayWindow?
    private var currentViewController: UIViewController?
    private var currentBox: BaseVCBox? {
        if let viewController = currentViewController {
            return WeakBox.init(viewController)
        } else {
            return nil
        }
    }
    private var currentOverlayContainers: [OverlayContainer] {
        get {
            if let box = currentBox, let currentContainers = map[box] {
                return currentContainers
            }
            return []
        }
        set {
            if let box = currentBox {
                map.updateValue(newValue, forKey: box)
            }
        }
    }
    
    init(factory: OverlayFactoryImp) {
        animationPerformerFactory = AnimationPerformerFactoryImp()
        map = [BaseVCBox: [OverlayContainer]]()
        overlaysFactory = factory
    }
}

// MARK: - OverlayManager
extension OverlayManagerOf {

    func addOverlayWindowWithFrame(_ frame: CGRect, level: UIWindow.Level) {
        let window = OverlayWindow(frame: frame)
        window.windowLevel = level + 1
        window.rootViewController = OverlayWindowRootViewController()
        window.isHidden = false
        
        overlayWindow = window
    }
    
    func displayOverlay(_ overlay: OverlayFactoryImp.OverlayType, configuration: OverlayDisplayConfiguration) -> DisplayedOverlayRemover? {
        
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
        
        return DisplayedOverlayRemover(overlay: overlayView, overlayRemovable: self)
    }
    
    func hideOverlays(animated: Bool) {
        for container in currentOverlayContainers {
            container.animator.removeOverlay(animated: animated, completion: nil)
        }
    }
}

// MARK: - PrivateHelpers
private extension OverlayManagerOf {

    func removeZombiesOverlays() {
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.map = strongSelf.map.filter({ return $0.key.item != nil })
            }
        })
    }
    
    func displayExistedOverlays() {
        for container in currentOverlayContainers {
            removeZombiesOverlays()
            container.animator.displayOverlayAfterAppearence()
        }
    }
}

// MARK: - OverlayRemovable
extension OverlayManagerOf: OverlayRemovable {

    func removeOverlay(_ overlay: UIView, animated: Bool) {
        let neededContainerArray = currentOverlayContainers.filter({ return $0.overlay == overlay })
        if let container = neededContainerArray.first {
            container.animator.removeOverlay(animated: animated) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.currentOverlayContainers = strongSelf.currentOverlayContainers.filter({ return $0.overlay != overlay })
                strongSelf.removeZombiesOverlays()
            }
        }
    }
}

// MARK: - ViewControllerObservable
extension OverlayManagerOf: ViewControllerObservable {
    
    func viewControllerBecomeActive(_ viewController: UIViewController) {
        self.currentViewController = viewController
        displayExistedOverlays()
    }
}
