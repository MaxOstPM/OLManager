//
//  BaseViewController+AvailableRegion.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func getAvailableRegionFor(level: OverlayLevel) -> CGRect {
        switch level {
            
        case .local:
            return self.view.frame.shrinked(with: self.localOverlayInsets)
            
        case .global:
            return self.view.frame.shrinked(with: self.globalOverlayInsets)
        }
    }
}
