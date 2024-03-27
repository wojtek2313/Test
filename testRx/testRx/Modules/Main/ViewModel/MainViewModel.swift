//
//  MainViewModel.swift
//  testRx
//
//  Created by Wojciech Kulas on 21/03/2024.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - Protocol Definition

protocol MainViewModelProtocol {
    var shopItems: Observable<[ShopItemContainer?]> { get }
    var priceOfBaket: Observable<Double> { get }
    var shopItemService: ShopItemServiceProtocol? { get }
    
    func setSelectedView(atIndex index: Int)
    func addShopItem(_ item: ShopItem)
    func removeShopItem(_ item: ShopItem)
}

// MARK: - Class Definition

class MainViewModel: MainViewModelProtocol {
    // MARK: - Private Properties
    
    private let disposeBag = DisposeBag()
    public private(set) var shopItemService: ShopItemServiceProtocol?
    private var selectedViewTypeRelay = PublishRelay<SelectedViewType>()
    private var shopItemStrategyRelay = PublishRelay<ShopItemStrategy>()
    private var onAddItemTapped = PublishRelay<ShopItem>()
    private var onRemoveItemTapped = PublishRelay<ShopItem>()
    private var priceOfBasketRelay = PublishRelay<Double>()
    private var changedBasketItemQuantity = false
    
    // MARK: - Public Properties
    
    public var shopItems: Observable<[ShopItemContainer?]> {
        shopItemStrategyRelay
            .flatMap { $0.shopItems }
            .asObservable()
    }
    
    public var priceOfBaket: Observable<Double> {
        priceOfBasketRelay.asObservable()
    }
    
    // MARK: - Initiailizers
    
    init(catalog: ShopItemStrategy, basket: ShopItemStrategy, responseFactory: ResponseFactoryProtocol) {
        bindSelcetedViewType(catalog: catalog, basket: basket, responseFactory: responseFactory)
        bindStoreageOfItemsInTheBasket()
    }
    
    // MARK: - Private Methods
    
    private func bindSelcetedViewType(catalog: ShopItemStrategy, basket: ShopItemStrategy, responseFactory: ResponseFactoryProtocol) {
        selectedViewTypeRelay.subscribe(onNext: { [weak self] viewType in
            guard let self = self else { return }
            let strategy = viewType == .catalog ? catalog : basket
            self.shopItemStrategyRelay.accept(strategy)
            self.bindShopItems(strategy, responseFactory)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindStoreageOfItemsInTheBasket() {
        Observable.combineLatest(shopItemStrategyRelay, onAddItemTapped)
            .subscribe {[weak self] strategy, item in
                guard let self = self,
                      self.changedBasketItemQuantity == true else { return }
                self.changedBasketItemQuantity = false
                strategy.addShopItem(item)
                self.handlePriceChanged()
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(shopItemStrategyRelay, onRemoveItemTapped)
            .subscribe {[weak self] strategy, item in
                guard let self = self,
                      self.changedBasketItemQuantity == true else { return }
                self.changedBasketItemQuantity = false
                strategy.removeShopItem(item)
                self.handlePriceChanged()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindShopItems(_ strategy: ShopItemStrategy, _ responseFactory: ResponseFactoryProtocol) {
        strategy.shopItems.subscribe { [weak self] items in
            var newItems: [ShopItemContainer] = []
            items.element?.forEach {
                if let newItem = $0 { newItems.append(newItem) }
            }
            self?.shopItemService = ShopItemService(items: newItems, responseFactory: responseFactory)
        }
        .disposed(by: disposeBag)
    }
    
    private func handlePriceChanged() {
        guard let service = self.shopItemService else { return }
        self.priceOfBasketRelay.accept(service.calculateBasePrice())
    }
    
    // MARK: - Public Methods
    
    public func setSelectedView(atIndex index: Int) {
        guard let selectedViewType = SelectedViewType(rawValue: index) else { return }
        selectedViewTypeRelay.accept(selectedViewType)
    }
    
    public func addShopItem(_ item: ShopItem) {
        changedBasketItemQuantity = true
        onAddItemTapped.accept(item)
    }
    
    public func removeShopItem(_ item: ShopItem) {
        changedBasketItemQuantity = true
        onRemoveItemTapped.accept(item)
    }
}
