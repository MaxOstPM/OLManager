//
//  OverlayWindow.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/25/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

protocol AbleToChangeOverlayViewControllerFrame {
    func applyAvailableRegionsWith(viewController: UIViewController)
}

final class OverlayWindow: UIWindow {
    
    var overlayViewController: OverlayWindowRootViewController? {
        return rootViewController as? OverlayWindowRootViewController
    }
}

extension OverlayWindow {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let rootVC = overlayViewController else {
            return nil
        }
        
        let performers = rootVC.animationPerformers
        var convertedPoint: CGPoint
        
        for performer in performers {
            let overlay = performer.overlay
            if overlay.isHidden || !overlay.isUserInteractionEnabled || overlay.alpha < 0.01 {
                return nil
            }
            convertedPoint = rootVC.view.convert(point, to: overlay)
            if overlay.point(inside: convertedPoint, with: event) {
                return overlay.hitTest(convertedPoint, with: event)
            }
        }
        return nil
    }
}

extension OverlayWindow: AbleToChangeOverlayViewControllerFrame {
    
    func applyAvailableRegionsWith(viewController: UIViewController) {
        OverlayLevel.allCases.forEach({ level in
            let region = viewController.getAvailableRegionFor(level: level)
            overlayViewController?.applyAvailableRegion(region, for: level)
        })
    }
}
