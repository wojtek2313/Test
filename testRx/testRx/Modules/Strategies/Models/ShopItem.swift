//
//  ShopItem.swift
//  testRx
//
//  Created by Wojciech Kulas on 21/03/2024.
//

import Foundation

public enum ShopItem {
    case potato, eggs, milk, banana
    
    var name: String {
        switch self {
        case .potato:
            return "potato_item_title".localized
        case .eggs:
            return "eggs_item_title".localized
        case .milk:
            return "milk_item_title".localized
        case .banana:
            return "banana_item_title".localized
        }
    }
    
    var priceInUSD: Double {
        switch self {
        case .potato: return 0.95
        case .eggs: return 2.10
        case .milk: return 1.30
        case .banana: return 0.73
        }
    }
    
    var unitType: UnitType {
        switch self {
        case .potato: return .bag
        case .eggs: return .dozen
        case .milk: return .bottle
        case .banana: return .kg
        }
    }
}
