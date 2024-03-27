//
//  ShopItemService.swift
//  testRx
//
//  Created by Wojciech Kulas on 26/03/2024.
//

import Foundation

// MARK: - Protocol Definition

protocol ShopItemServiceProtocol {
    func calculateBasePrice() -> Double
    func calculatePricesForEachCurrency() -> [String: Double]
}

// MARK: - Class Definition

class ShopItemService: ShopItemServiceProtocol {
    // MARK: - Private Properties
    
    private var items: [ShopItemContainer] = []
    private var responseFactory: ResponseFactoryProtocol
    
    // MARK: - Initializers
    
    init(items: [ShopItemContainer], responseFactory: ResponseFactoryProtocol) {
        self.items = items
        self.responseFactory = responseFactory
    }
    
    // MARK: - Public Methods
    
    public func calculateBasePrice() -> Double {
        return items
            .filter { $0.quantity != 0.0 }
            .map { $0.quantity * $0.item.priceInUSD }
            .reduce(0, +)
            .rounded(toPlaces: 2)
    }
    
    public func calculatePricesForEachCurrency() -> [String: Double] {
        let price = calculateBasePrice()
        var priceInCurrency: [String: Double] = [:]
        responseFactory.create()
            .forEach { priceInCurrency[$0.key] = ($0.value * price).rounded(toPlaces: 2) }
        return priceInCurrency
    }
}
