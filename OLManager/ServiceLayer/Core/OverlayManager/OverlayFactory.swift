//
//  OverlayFactory.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/25/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

public protocol OverlayFactory {
    associatedtype OverlayType
    
    func makeOverlayWith(type: OverlayType) -> UIView
}
