//
//  StaticAnimationPerforme.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import Foundation

final class StaticAnimationPerformer: BaseAnimationPerformer {

    override func displayOverlay() {
        setupOverlayFrame()
        addOverlayOnSuperview()
    }
    
    override func removeOverlay(animated: Bool, completion: OptionalCompletion) {
        removeOverlayFromSuperview()
        completion?()
    }
}
