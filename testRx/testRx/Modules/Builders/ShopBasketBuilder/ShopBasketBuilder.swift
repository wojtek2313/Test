//
//  ShopBasketBuilder.swift
//  testRx
//
//  Created by Wojciech Kulas on 22/03/2024.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - Protocol Definition

protocol ShopBasketBuilderProtocol {
    func increasePotatoBag()
    func decreasePotatoBag()
    
    func increaseEggsDozen()
    func decreaseEggsDozen()

    func increaseMilkBottles()
    func decreaseMilkBottles()
    
    func increaseBananaQuantity()
    func decreaseBananaQuantity()
    
    func build() -> Observable<ShopBasket?>
}

// MARK: - Class Definition

class ShopBasketBuilder: ShopBasketBuilderProtocol {
    
    // MARK: - Private Properties
    
    private var potatos = BehaviorRelay<ShopItemContainer>(value: ShopItemContainer(item: .potato, quantity: 0))
    private var eggs = BehaviorRelay<ShopItemContainer>(value: ShopItemContainer(item: .eggs, quantity: 0))
    private var milk = BehaviorRelay<ShopItemContainer>(value: ShopItemContainer(item: .milk, quantity: 0))
    private var banana = BehaviorRelay<ShopItemContainer>(value: ShopItemContainer(item: .banana, quantity: 0))
    
    // MARK: - Public Methods
    
    public func increasePotatoBag() {
        let quantity = potatos.value.quantity + 1
        potatos.accept(ShopItemContainer(item: .potato, quantity: quantity))
    }
    
    public func decreasePotatoBag() {
        var quantity = potatos.value.quantity
        guard quantity > 0 else { return }
        quantity = quantity - 1
        potatos.accept(ShopItemContainer(item: .potato, quantity: quantity))
    }
    
    public func increaseEggsDozen() {
        let quantity = eggs.value.quantity + 1
        eggs.accept(ShopItemContainer(item: .eggs, quantity: quantity))
    }

    public func decreaseEggsDozen() {
        var quantity = eggs.value.quantity
        guard quantity > 0 else { return }
        quantity = quantity - 1
        eggs.accept(ShopItemContainer(item: .eggs, quantity: quantity))
    }

    public func increaseMilkBottles() {
        let quantity = milk.value.quantity + 1
        milk.accept(ShopItemContainer(item: .milk, quantity: quantity))
    }

    public func decreaseMilkBottles() {
        var quantity = milk.value.quantity
        guard quantity > 0 else { return }
        quantity = quantity - 1
        milk.accept(ShopItemContainer(item: .milk, quantity: quantity))
    }

    public func increaseBananaQuantity() {
        let quantity = banana.value.quantity + 1
        banana.accept(ShopItemContainer(item: .banana, quantity: quantity))
    }

    public func decreaseBananaQuantity() {
        var quantity = banana.value.quantity
        guard quantity > 0 else { return }
        quantity = quantity - 1
        banana.accept(ShopItemContainer(item: .banana, quantity: quantity))
    }
    
    public func build() -> Observable<ShopBasket?> {
        let shopItems = [potatos, eggs, milk, banana]
        return Observable
            .combineLatest(shopItems)
            .map { [weak self] _ in
                guard let self = self else { return nil }
                return ShopBasket(
                    potatos: self.potatos.value,
                    eggs: self.eggs.value,
                    milk: self.milk.value,
                    banana: self.banana.value
                )
            }
    }
}
