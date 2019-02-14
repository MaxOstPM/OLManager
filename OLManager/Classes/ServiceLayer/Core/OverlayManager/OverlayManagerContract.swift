//
//  OverlayContract.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/25/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

public enum Edge {
    case top
    case bottom
    // TODO: add left and right edges
}

// MARK: OverlayManager
public protocol ViewControllerObservable {
    func viewControllerBecomeActive(_ viewController: UIViewController)
}

protocol OverlayRemovable: class {
    func removeOverlay(_ overlay: UIView, animated: Bool)
}
