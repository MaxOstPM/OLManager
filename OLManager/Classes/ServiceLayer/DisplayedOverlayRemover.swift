//
//  DisplayedOverlayRemover.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/1/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

public protocol OverlayRemover {
    func removeOverlay(animated: Bool)
}

public final class OverlayRemoverImp: OverlayRemover {
    
    private weak var overlay: UIView?
    private weak var overlayRemovable: OverlayRemovable?
    
    init(overlay: UIView? = nil, overlayRemovable: OverlayRemovable? = nil) {
        self.overlay = overlay
        self.overlayRemovable = overlayRemovable
    }
}

public extension OverlayRemoverImp {
    
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
