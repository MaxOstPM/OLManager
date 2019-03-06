//
//  OverlayWindowRootViewController.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/29/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

class OverlayWindowRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
    }
}

extension OverlayWindowRootViewController {
    
    func addNewOverlayWith(animationPerformer: AnimationPerformer) {
        if !animationPerformers.contains(where: { return $0.overlay == animationPerformer.overlay }) {
            animationPerformers.append(animationPerformer)
        }
        if animationPerformer.overlay.superview == nil {
            view.addSubview(animationPerformer.overlay)
        }
    }
    
    func removeOverlayWith(animationPerformer: AnimationPerformer) {
        animationPerformer.overlay.removeFromSuperview()
        animationPerformers = animationPerformers.filter({ return $0.overlay != animationPerformer.overlay })
    }
}
