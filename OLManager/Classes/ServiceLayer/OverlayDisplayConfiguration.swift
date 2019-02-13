//
//  OverlayDisplayConfiguration.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import Foundation

public struct OverlayDisplayConfiguration {
    let pinningEdge: Edge
    let animationType: AnimationType
}

extension OverlayDisplayConfiguration {
    init(pinToEdge: Edge, animationType: AnimationType) {
        self.pinningEdge = pinToEdge
        self.animationType = animationType
    }
}

enum AnimationType {
    case fadeIn
    case slide
    case none
}
