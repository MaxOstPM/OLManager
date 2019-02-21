//
//  BaseAnimationPerformer.swift
//  OLManager
//
//  Created by Максим Остапчук on 2/21/19.
//

import Foundation

public class BaseAnimationPerformer: AnimationPerformer {
    
    private var overlayFrameCalculator: OverlayFrameCalculator
    private var windowRootViewController: OverlayWindowRootViewController
    
    var overlay: UIView
    var displayConfig: OverlayDisplayConfiguration
    
    var availableRegion: CGRect
    open var incomeAnimationDuration: Double {
        return 0.0
    }
    open var outcomeAnimationDuration: Double {
        return 0.0
    }
    
    required init(windowRootViewController: OverlayWindowRootViewController, overlayedViewController: UIViewController, overlay: UIView, displayConfig: OverlayDisplayConfiguration) {
        self.windowRootViewController = windowRootViewController
        self.availableRegion = overlayedViewController.availableRegion
        self.overlayFrameCalculator = OverlayFrameCalculatorImp()
        self.overlay = overlay
        self.displayConfig = displayConfig
    }
    
    deinit {
        print("Animator deinit")
    }
    
    // MARK: BaseAnimationPerformer
    open func displayOverlay() {
        assertionFailure()
    }
    
    open func removeOverlay(animated: Bool, completion: OptionalCompletion) {
        assertionFailure()
    }
    
    func displayOverlayWithoutAnimation() {
        setupOverlayFrame()
        addOverlayOnSuperview()
    }
}

// MARK: Helpers
extension BaseAnimationPerformer {
    
    func setupOverlayFrame() {
        overlay.frame = overlayFrameCalculator.makeFrameFor(overlay: overlay, inside: availableRegion, with: displayConfig)
    }
    
    func addOverlayOnSuperview() {
        windowRootViewController.addNewOverlayWith(animationPerformer: self)
    }
    
    func removeOverlayFromSuperview() {
        windowRootViewController.removeOverlayWith(animationPerformer: self)
    }
}
