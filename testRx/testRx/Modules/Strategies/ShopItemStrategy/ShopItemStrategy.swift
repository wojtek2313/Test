//
//  ShopItemStrategy.swift
//  testRx
//
//  Created by Wojciech Kulas on 21/03/2024.
//

import Foundation
import RxSwift

// MARK: - Protocol Definition

protocol ShopItemStrategy {
    var shopItems: Observable<[ShopItemContainer?]> { get }
    
    func addShopItem(_ item: ShopItem)
    func removeShopItem(_ item: ShopItem)
}
