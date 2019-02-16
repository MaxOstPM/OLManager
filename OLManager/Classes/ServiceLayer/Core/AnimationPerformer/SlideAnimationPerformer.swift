//
//  SlideAnimationPerformer.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

final class SlideAnimationPerformer: BaseAnimationPerformer {
    
    override var incomeAnimationDuration: Double {
        return 0.55
    }
    
    override var outcomeAnimationDuration: Double {
        return 0.2
    }
    
    override func displayOverlay() {
        setupOverlayFrame()
        let originFrame = overlay.frame
        
        switch displayConfig.pinningLocation.verticalEdge {
        case .top, .middle:
            overlay.frame.origin.y = availableRegion.origin.y - overlay.frame.height
        case .bottom:
            overlay.frame.origin.y = availableRegion.maxY + overlay.frame.height
        }
        addOverlayOnSuperview()
        
        UIView.animate(withDuration: incomeAnimationDuration, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.overlay.frame = originFrame
        }, completion: nil)
    }
    
    override func removeOverlay(animated: Bool, completion: OptionalCompletion) {
        func remove() {
            removeOverlayFromSuperview()
            completion?()
        }
        
        var finalYCoord: CGFloat
        switch displayConfig.pinningLocation.verticalEdge {
        case .top, .middle:
            finalYCoord = availableRegion.origin.y - overlay.frame.height
        case .bottom:
            finalYCoord = availableRegion.maxY + overlay.frame.height
        }
        
        if animated {
            UIView.animate(withDuration: incomeAnimationDuration, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.overlay.frame.origin.y = finalYCoord
                }, completion: { _ in
                    remove()
            })
        } else {
            remove()
        }
    }
}
