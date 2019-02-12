//
//  OverlayDisplayConfiguration.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/5/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import Foundation

struct OverlayDisplayConfiguration {
    let pinningEdge: Edge
    let animationType: AnimationType
    // TODO: Add additional overlay insets
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
