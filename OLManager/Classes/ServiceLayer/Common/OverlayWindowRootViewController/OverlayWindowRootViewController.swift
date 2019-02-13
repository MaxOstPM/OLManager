//
//  OverlayWindowRootViewController.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/29/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

class OverlayWindowRootViewController: UIViewController {
    
    private (set) var overlays: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
    }
}

extension OverlayWindowRootViewController {
    
    func addNewOverlay(_ overlay: UIView) {
        overlays.append(overlay)
        view.addSubview(overlay)
    }
    
    func removeOverlay(_ overlay: UIView) {
        overlay.removeFromSuperview()
        overlays = overlays.filter({ return $0 != overlay })
    }
}
