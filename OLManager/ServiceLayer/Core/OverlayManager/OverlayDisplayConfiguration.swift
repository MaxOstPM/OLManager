//
//  OverlayDisplayConfiguration.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import Foundation

public struct OverlayDisplayConfiguration {
    let pinningLocation: PinningLocation
    let animationType: AnimationType
    let additionalInsets: UIEdgeInsets?
    let overlayLevel: OverlayLevel
}

public extension OverlayDisplayConfiguration {
    init(animationType: AnimationType, pinningLocation: PinningLocation, overlayLevel: OverlayLevel, additionalInsets: UIEdgeInsets? = nil) {
        self.pinningLocation = pinningLocation
        self.animationType = animationType
        self.additionalInsets = additionalInsets
        self.overlayLevel = overlayLevel
    }
}

public enum AnimationType {
    case fadeIn
    case slide
    case none
}

public enum OverlayLevel {
    case local
    case global
}
