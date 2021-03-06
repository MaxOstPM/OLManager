//
//  BaseAnimationPerformer.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

public typealias OptionalCompletion = (() -> Void)?

protocol AnimationPerformer {
    init(windowRootViewControllerConnector: OverlayWindowRootViewControllerConnector,
         overlay: UIView,
         level: OverlayLevel,
         displayConfig: OverlayDisplayConfiguration)
    
    func displayOverlayWithoutAnimation()
    func displayOverlay()
    func removeOverlay(animated: Bool, completion: OptionalCompletion)
    
    var overlay: UIView { get }
}
