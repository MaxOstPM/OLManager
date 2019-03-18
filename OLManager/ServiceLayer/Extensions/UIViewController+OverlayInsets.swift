//
//  UIViewController+OverlayInsets.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/31/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @objc open var overlayInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            // TODO:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
}
