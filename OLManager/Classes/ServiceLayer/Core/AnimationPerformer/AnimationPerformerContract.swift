//
//  BaseAnimationPerformer.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

typealias OptionalCompletion = (() -> Void)?

protocol AnimationPerformer {
    init(windowRootViewController: OverlayWindowRootViewController, overlayedViewController: UIViewController, overlay: Overlay, displayConfig: OverlayDisplayConfiguration)
    
    func displayOverlayAfterAppearence()
    func displayOverlay()
    func removeOverlay(animated: Bool, completion: OptionalCompletion)
}

class BaseAnimationPerformer: AnimationPerformer {

    private var overlayFrameCalculator: OverlayFrameCalculator
    private var windowRootViewController: OverlayWindowRootViewController
    
    var overlay: Overlay
    var displayConfig: OverlayDisplayConfiguration
    
    var availableRegion: CGRect
    var incomeAnimationDuration: Double {
        return 0.0
    }
    var outcomeAnimationDuration: Double {
        return 0.0
    }
    
    required init(windowRootViewController: OverlayWindowRootViewController, overlayedViewController: UIViewController, overlay: Overlay, displayConfig: OverlayDisplayConfiguration) {
        self.windowRootViewController = windowRootViewController
        self.availableRegion = overlayedViewController.availableRegion
        self.overlayFrameCalculator = OverlayFrameCalculatorImp()
        self.overlay = overlay
        self.displayConfig = displayConfig
    }
    
    // MARK: BaseAnimationPerformer
    func displayOverlay() {
        assertionFailure()
    }
    
    func removeOverlay(animated: Bool, completion: OptionalCompletion) {
        assertionFailure()
    }
    
    func displayOverlayAfterAppearence() {
        addOverlayOnSuperview()
    }
}

// MARK: Helpers
extension BaseAnimationPerformer {
    
    func setupOverlayFrame() {
        overlay.frame = overlayFrameCalculator.makeFrameFor(overlay: overlay, inside: availableRegion, onEdge: displayConfig.pinningEdge)
    }
    
    func addOverlayOnSuperview() {
        windowRootViewController.addNewOverlay(overlay)
    }
    
    func removeOverlayFromSuperview() {
        windowRootViewController.removeOverlay(overlay)
    }
}
