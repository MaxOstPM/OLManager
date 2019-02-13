//
//  WeakBox.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/31/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import Foundation

private typealias WeakItem = AnyObject & Hashable

final class WeakBox<T: WeakItem>: Hashable {
    
    private (set) weak var item: T?
    private var itemHashValue: Int
    
    var hashValue: Int {
        return itemHashValue
    }
    
    init(_ item: T) {
        self.item = item
        self.itemHashValue = item.hashValue
    }
}

extension WeakBox {
    static func == (lhs: WeakBox<T>, rhs: WeakBox<T>) -> Bool {
        return lhs.item === rhs.item
    }
}
