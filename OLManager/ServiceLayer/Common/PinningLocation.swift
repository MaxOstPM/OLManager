//
//  PinningLocation.swift
//  OLManager
//
//  Created by Максим Остапчук on 2/16/19.
//

import Foundation

public enum VerticalEdge {
    case top
    case bottom
    case middle
}

public enum HorizontalEdge {
    case left
    case rigth
    case middle
}

public struct PinningLocation {
    let verticalEdge: VerticalEdge
    let horizontalEdge: HorizontalEdge
}

public extension PinningLocation {
    init(horizontalEdge: HorizontalEdge = .middle, verticalEdge: VerticalEdge = .middle) {
        self.init(verticalEdge: verticalEdge, horizontalEdge: horizontalEdge)
    }
}
