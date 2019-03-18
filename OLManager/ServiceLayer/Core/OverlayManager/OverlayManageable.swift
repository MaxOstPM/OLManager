//
//  DisplayedOverlayRemover.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 2/1/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

public protocol OverlayManageable {
    func removeOverlay(animated: Bool)
    func hideOverlay(animated: Bool)
    func showOverlay(animated: Bool)
}

internal final class OverlayManageableImp: OverlayManageable {
    
    private weak var overlay: UIView?
    private weak var overlayManageble: OverlayManageableConnection?
    
    init(overlay: UIView? = nil, overlayManageble: OverlayManageableConnection? = nil) {
        self.overlay = overlay
        self.overlayManageble = overlayManageble
    }
    
    deinit {
        removeOverlay(animated: false)
    }
}

// MARK: - OverlayManageable
extension OverlayManageableImp {
    
    func removeOverlay(animated: Bool) {
        defer {
            overlayManageble = nil
        }
        guard let unwrappedOverlay = overlay else {
            return
        }
        overlayManageble?.removeOverlay(unwrappedOverlay, animated: animated)
    }
    
    func hideOverlay(animated: Bool) {
        guard let unwrappedOverlay = overlay else {
            return
        }
        overlayManageble?.hideOverlay(unwrappedOverlay, animated: animated)
    }
    
    func showOverlay(animated: Bool) {
        guard let unwrappedOverlay = overlay else {
            return
        }
        overlayManageble?.showOverlay(unwrappedOverlay, animated: animated)
    }
}
