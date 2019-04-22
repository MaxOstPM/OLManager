//
//  BaseAnimationPerformer.swift
//  OLManager
//
//  Created by Максим Остапчук on 2/21/19.
//

import Foundation

public class BaseAnimationPerformer: AnimationPerformer {
    
    private let overlayFrameCalculator: OverlayFrameCalculator
    private let windowRootViewControllerConnector: OverlayWindowRootViewControllerConnector
    private let level: OverlayLevel
    
    let overlay: UIView
    let displayConfig: OverlayDisplayConfiguration
    
    var availableRegion: CGRect {
        return windowRootViewControllerConnector.getAvailableRegionFor(overlayLevel: level)
    }
    
    open var incomeAnimationDuration: Double {
        return 0.0
    }
    open var outcomeAnimationDuration: Double {
        return 0.0
    }
    
    required init(windowRootViewControllerConnector: OverlayWindowRootViewControllerConnector,
                  overlay: UIView,
                  level: OverlayLevel,
                  displayConfig: OverlayDisplayConfiguration) {
        self.windowRootViewControllerConnector = windowRootViewControllerConnector
        self.overlayFrameCalculator = OverlayFrameCalculatorImp()
        self.overlay = overlay
        self.displayConfig = displayConfig
        self.level = level
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
        let availableRegion = windowRootViewControllerConnector.getAvailableRegionFor(overlayLevel: level)
        overlay.frame = overlayFrameCalculator.makeFrameFor(overlay: overlay, inside: availableRegion, with: displayConfig)
    }
    
    func addOverlayOnSuperview() {
        windowRootViewControllerConnector.addNewOverlayWith(animationPerformer: self)
    }
    
    func removeOverlayFromSuperview() {
        windowRootViewControllerConnector.removeOverlayWith(animationPerformer: self)
    }
}
