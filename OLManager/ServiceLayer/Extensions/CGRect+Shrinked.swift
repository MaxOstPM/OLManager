//
//  CGRect+Shrinked.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/31/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

extension CGRect {
    
    
    func shrinked(with insets: UIEdgeInsets) -> CGRect {
        let y = insets.top
        let x = insets.left
        let width = self.size.width - insets.left - insets.right
        let height = self.size.height - insets.bottom - insets.top
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
