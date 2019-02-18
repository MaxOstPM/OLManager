//
//  LayoutHelper.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/29/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

protocol OverlayFrameCalculator {
    func makeFrameFor(overlay: UIView, inside availableRegion: CGRect, with configuration: OverlayDisplayConfiguration) -> CGRect
}

final class OverlayFrameCalculatorImp: OverlayFrameCalculator {
    
    func makeFrameFor(overlay: UIView, inside availableRegion: CGRect, with configuration: OverlayDisplayConfiguration) -> CGRect {
        
        let overlaySize = overlay.frame.size
        var point = CGPoint.init()
        
        if overlaySize.width <= availableRegion.size.width && overlaySize.height <= availableRegion.size.height {
            
            switch configuration.pinningLocation.horizontalEdge {
            case .left:
                point.x = availableRegion.minX
            case .rigth:
                point.x = availableRegion.maxX - overlaySize.width
            case .middle:
                point.x = availableRegion.midX - overlaySize.width / 2
            }
            
            switch configuration.pinningLocation.verticalEdge {
            case .top:
                point.y = availableRegion.minY
            case .bottom:
                point.y = availableRegion.maxY - overlaySize.height
            case .middle:
                point.y = availableRegion.midY - overlaySize.height / 2
            }
            
            if let additionalInsets = configuration.additionalInsets {
                point.x += additionalInsets.left - additionalInsets.right
                point.y += additionalInsets.top - additionalInsets.bottom
            }
            
            let overlayFrame = CGRect(x: point.x, y: point.y, width: overlaySize.width, height: overlaySize.height)
            return availableRegion.contains(overlayFrame) ? overlayFrame : CGRect.zero
        } else {
            return CGRect.zero
        }
    }
}
