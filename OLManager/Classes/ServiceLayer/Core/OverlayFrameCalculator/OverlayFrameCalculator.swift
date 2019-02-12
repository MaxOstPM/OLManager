//
//  LayoutHelper.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/29/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

protocol OverlayFrameCalculator {
    func makeFrameFor(overlay: Overlay, inside availableRegion: CGRect, onEdge edge: Edge) -> CGRect
}

final class OverlayFrameCalculatorImp: OverlayFrameCalculator {
    
    func makeFrameFor(overlay: Overlay, inside availableRegion: CGRect, onEdge edge: Edge) -> CGRect {
        let overlaySize = overlay.frame.size
        
        if overlaySize.width <= availableRegion.size.width && overlaySize.height <= availableRegion.size.height {
            var point: CGPoint
            switch edge {
            case .top:
                point = CGPoint(x: 0.0, y: availableRegion.minY)
            case .bottom:
                let y = availableRegion.maxY - overlaySize.height
                point = CGPoint(x: 0.0, y: y)
            }
            
            return CGRect(x: point.x, y: point.y, width: overlaySize.width, height: overlaySize.height)
        } else {
            return CGRect.zero
        }
    }
}
