//
//  OverlayWindow.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/25/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

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
        
        var convertedPoint: CGPoint
        for overlay in rootVC.overlays {
            convertedPoint = rootVC.view.convert(point, to: overlay)
            if overlay.point(inside: convertedPoint, with: event) {
                return overlay
            }
        }
        return nil
    }
}
