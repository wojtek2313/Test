//
//  UIFont+Ext.swift
//  testRx
//
//  Created by Wojciech Kulas on 25/03/2024.
//

import UIKit

public extension UIFont {
    static var avenirHeavyOpaqueTitle: UIFont {
        return UIFont(name: "Avenir-HeavyOblique", size: 16) ?? UIFont()
    }
    
    static var smallAvenirHeavyOpaque: UIFont {
        return UIFont(name: "Avenir-HeavyOblique", size: 9) ?? UIFont()
    }
    
    static var mediumAvenirHeavyOpaque: UIFont {
        return UIFont(name: "Avenir-HeavyOblique", size: 12) ?? UIFont()
    }
}
