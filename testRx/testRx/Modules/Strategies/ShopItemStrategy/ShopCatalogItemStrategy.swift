//
//  CatalogShopItemStrategy.swift
//  testRx
//
//  Created by Wojciech Kulas on 21/03/2024.
//

import Foundation
import RxSwift

// MARK: - Class Definition

class ShopCatalogItemStrategy: ShopItemStrategy {
    // MARK: - Private Properties
    
    private let shopBasketBuilder: ShopBasketBuilderProtocol
    
    // MARK: - Public Properties
    
    var shopItems: Observable<[ShopItemContainer?]> {
        return shopBasketBuilder
            .build()
            .map { [$0?.potatos, $0?.eggs, $0?.milk, $0?.banana] }
    }
    
    // MARK: - Initializers
    
    init(shopBasketBuilder: ShopBasketBuilderProtocol) {
        self.shopBasketBuilder = shopBasketBuilder
    }
    
    // MARK: - Private Methods
    
    private func handleShopItem(_ item: ShopItem, shouldBeRemoved: Bool = true) {
        switch item {
        case .potato: shouldBeRemoved ? shopBasketBuilder.decreasePotatoBag() : shopBasketBuilder.increasePotatoBag()
        case .eggs: shouldBeRemoved ? shopBasketBuilder.decreaseEggsDozen() : shopBasketBuilder.increaseEggsDozen()
        case .milk: shouldBeRemoved ? shopBasketBuilder.decreaseMilkBottles() : shopBasketBuilder.increaseMilkBottles()
        case .banana: shouldBeRemoved ? shopBasketBuilder.decreaseBananaQuantity() : shopBasketBuilder.increaseBananaQuantity()
        }
    }
    
    // MARK: - Public Methods
    
    func addShopItem(_ item: ShopItem) {
        handleShopItem(item, shouldBeRemoved: false)
    }
    
    func removeShopItem(_ item: ShopItem) {
        handleShopItem(item)
    }
}
