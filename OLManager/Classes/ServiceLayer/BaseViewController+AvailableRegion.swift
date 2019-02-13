//
//  BaseViewController+AvailableRegion.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var availableRegion: CGRect {
        return self.view.frame.shrinked(with: self.overlayInsets)
    }
}
