//
//  OverlayWindowRootViewControllerContract.swift
//  OLManager
//
//  Created by Максим Остапчук on 4/18/19.
//

import UIKit

typealias OverlayWindowRootViewControllerConnector = ExistedOverlayManagable & OverlayWindowAvailableRegionGetter

protocol ExistedOverlayManagable {
    func addNewOverlayWith(animationPerformer: AnimationPerformer)
    func removeOverlayWith(animationPerformer: AnimationPerformer)
}

protocol OverlayWindowAvailableRegionGetter {
    func getAvailableRegionFor(overlayLevel: OverlayLevel) -> CGRect
}
