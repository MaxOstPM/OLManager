//
//  OverlayContract.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/25/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

// MARK: - OverlayManager
public protocol ViewControllerObservable {
    func viewControllerBecomeActive(_ viewController: UIViewController)
}

// TODO: - Rename
protocol OverlayManageableConnection: class {
    func removeOverlay(_ overlay: UIView, animated: Bool)
    func hideOverlay(_ overlay: UIView, animated: Bool)
    func showOverlay(_ overlay: UIView, animated: Bool)
}
