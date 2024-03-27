//
//  UIView+Ext.swift
//  testRx
//
//  Created by Wojciech Kulas on 21/03/2024.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    static func toString() -> String {
        return String(describing: self)
    }
}
