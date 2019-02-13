//
//  FadeInAnimationPerformer.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

final class FadeInAnimationPerformer: BaseAnimationPerformer {
    
    override var incomeAnimationDuration: Double {
        return 0.4
    }
    
    override var outcomeAnimationDuration: Double {
        return 0.2
    }
    
    override func displayOverlay() {
        overlay.alpha = 0.0
        setupOverlayFrame()
        addOverlayOnSuperview()
        
        UIView.animate(withDuration: incomeAnimationDuration) { [weak self] in
            self?.overlay.alpha = 1.0
        }
    }
    
    override func removeOverlay(animated: Bool, completion: OptionalCompletion) {
        func remove() {
            removeOverlayFromSuperview()
            completion?()
        }
        
        if animated {
            UIView.animate(withDuration: outcomeAnimationDuration, animations: { [weak self] in
                self?.overlay.alpha = 0.0
            }) { _ in
                remove()
            }
        } else {
            remove()
        }
    }
}
