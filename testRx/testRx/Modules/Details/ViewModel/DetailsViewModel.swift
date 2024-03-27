//
//  DetailsViewModel.swift
//  testRx
//
//  Created by Wojciech Kulas on 26/03/2024.
//

import Foundation
import RxSwift

// MARK: - Protocol Definition

protocol DetailsViewModelProtocol {
    var basketPrices: Observable<[String]> { get }
    var basketPriceInUSD: Double { get }
}

// MARK: - Class Definition

class DetailsViewModel: DetailsViewModelProtocol {
    // MARK: - Private Properties
    
    private var shopItemService: ShopItemServiceProtocol?
    
    // MARK: - Public Properties
    
    public var basketPrices: Observable<[String]> {
        return Observable.just(
            shopItemService?.calculatePricesForEachCurrency()
                .map { "\($0.value)(\($0.key))" } ?? []
        )
    }
    
    public var basketPriceInUSD: Double {
        return shopItemService?.calculateBasePrice() ?? 0.0
    }
    
    // MARK: - Initializers
    
    init(shopItemService: ShopItemServiceProtocol) {
        self.shopItemService = shopItemService
    }
}
