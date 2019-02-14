//
//  AnimationPerformerFactory.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

protocol AnimationPerformerFactory {
//    func makeAnimationPerformerFor(_ overlay: UIView, with type: AnimationType, windowRootViewController: OverlayWindowRootViewController, overlayedViewController: UIViewController, displayConfig: OverlayDisplayConfiguration) -> AnimationPerformer
}

final class AnimationPerformerFactoryImp: AnimationPerformerFactory {
    
    func makeAnimationPerformerFor(_ overlay: UIView, with type: AnimationType, windowRootViewController: OverlayWindowRootViewController, overlayedViewController: UIViewController, displayConfig: OverlayDisplayConfiguration) -> AnimationPerformer {
        let PerformerType: BaseAnimationPerformer.Type
        
        switch type {
        case .fadeIn:
            PerformerType = FadeInAnimationPerformer.self
        case .slide:
            PerformerType = SlideAnimationPerformer.self
        case .none:
            PerformerType = StaticAnimationPerformer.self
        }
        
        return PerformerType.init(windowRootViewController: windowRootViewController, overlayedViewController: overlayedViewController, overlay: overlay, displayConfig: displayConfig)
    }
}
