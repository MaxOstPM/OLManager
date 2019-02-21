//
//  OverlayLevel.swift
//  OLManager
//
//  Created by Максим Остапчук on 2/21/19.
//

import Foundation

public protocol OverlayLevelHolder {
    var overlayLevel: OverlayLevel { get }
}

public enum OverlayLevel {
    case local
    case global
}
