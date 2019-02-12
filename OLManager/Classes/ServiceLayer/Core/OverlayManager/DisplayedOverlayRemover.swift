//
//  DisplayedOverlayRemover.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/1/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import Foundation

final class DisplayedOverlayRemover {
    
    private weak var overlay: Overlay?
    private weak var overlayRemovable: OverlayRemovable?
    
    init(overlay: Overlay? = nil, overlayRemovable: OverlayRemovable? = nil) {
        self.overlay = overlay
        self.overlayRemovable = overlayRemovable
    }
}

extension DisplayedOverlayRemover {
    
    func removeOverlay(animated: Bool) {
        defer {
            overlayRemovable = nil
        }
        guard let unwrappedOverlay = overlay else {
            return
        }
        overlayRemovable?.removeOverlay(unwrappedOverlay, animated: animated)
    }
}
