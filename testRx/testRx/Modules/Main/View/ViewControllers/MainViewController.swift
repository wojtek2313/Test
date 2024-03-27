//
//  MainViewController.swift
//  testRx
//
//  Created by Wojciech Kulas on 21/03/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

// MARK: - Class Definition

class MainViewController: UIViewController {
    // MARK: - Constants
    
    private struct Constants {
        static let numberOfColumnsInCollectionView = 2
        static let minimumInterItemSpacing: CGFloat = 2
        static let minimumLineSpacing: CGFloat = 10
        static let customItemWidth: CGFloat = 135
        static let customItemHeight: CGFloat = 130
    }
    
    // MARK: - Private Properties
    
    private let disposeBag = DisposeBag()
    private var viewModel: MainViewModelProtocol
    private var router: NavigationRouter<ShopItemServiceProtocol, DetailsNavigationType>
    
    // MARK: - UI
    
    private var segmentedControl: UISegmentedControl = {
        let segementedItems = [
            "catalog_section",
            "basket_section"
        ].map { $0.localized }
        
        let segmentedControl = UISegmentedControl(items: segementedItems)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var collectionView: UICollectionView = {
        let collectionViewFlowLayout = TestRxFlowLayout(
            numberOfColumns: Constants.numberOfColumnsInCollectionView,
            minimumInteritemSpacing: Constants.minimumInterItemSpacing,
            minimumLineSpacing: Constants.minimumLineSpacing,
            customItemWidth: Constants.customItemWidth,
            customItemHeight: Constants.customItemHeight
        )
        collectionViewFlowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let cellReuseIdentifier = String(describing: MainCollectionViewCell.self)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        return collectionView
    }()
    
    private var bottomTabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("checkout_button".localized, for: .selected)
        button.setTitle("checkout_button".localized, for: .focused)
        button.setTitle("checkout_button".localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        return button
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    init(viewModel: MainViewModelProtocol, router: NavigationRouter<ShopItemServiceProtocol, DetailsNavigationType>) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifetime Methods
    
    override func loadView() {
        super.loadView()
        addSubviews()
        addConstraints()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        self.view.backgroundColor = .white
        self.view.addSubviews([
            segmentedControl,
            collectionView,
            bottomTabBarView
        ])
        
        bottomTabBarView.addSubviews([
            checkoutButton,
            priceLabel
        ])
    }
    
    private func addConstraints() {
        /// Segmented Control Constraints
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: TestRxSize.mSize).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TestRxSize.large).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -TestRxSize.large).isActive = true
        
        /// Collection View Constraints
        collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: TestRxSize.mSize).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomTabBarView.topAnchor, constant: TestRxSize.zero).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TestRxSize.sSize).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -TestRxSize.sSize).isActive = true
        
        /// Bottom Tab Bar View Constraints
        bottomTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: TestRxSize.zero).isActive = true
        bottomTabBarView.heightAnchor.constraint(equalToConstant: TestRxSize.largeSize).isActive = true
        bottomTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TestRxSize.zero).isActive = true
        bottomTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: TestRxSize.zero).isActive = true
        
        /// Checkout Button Constraints
        checkoutButton.leadingAnchor.constraint(equalTo: bottomTabBarView.leadingAnchor, constant: TestRxSize.sSize).isActive = true
        checkoutButton.centerYAnchor.constraint(equalTo: bottomTabBarView.centerYAnchor).isActive = true
        checkoutButton.heightAnchor.constraint(equalToConstant: TestRxSize.large).isActive = true
        checkoutButton.widthAnchor.constraint(equalToConstant: TestRxSize.largeSize).isActive = true
        
        /// Price Label Constraints
        priceLabel.trailingAnchor.constraint(equalTo: bottomTabBarView.trailingAnchor, constant: -TestRxSize.sSize).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: bottomTabBarView.centerYAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: TestRxSize.large).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: TestRxSize.largeSize).isActive = true
    }
    
}

// MARK: - Setup Observers

extension MainViewController {
    private func setupObservers() {
        bindCollectionView()
        bindSegemntedControl()
        bindPriceOfBasket()
        bindCheckoutButton()
    }
    
    private func bindSegemntedControl() {
        segmentedControl.rx
            .value
            .asDriver()
            .drive { [weak self] selectedViewIndex in
                guard let self = self else { return }
                self.viewModel.setSelectedView(atIndex: selectedViewIndex)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        viewModel.shopItems
            .bind(to: collectionView.rx.items(
                cellIdentifier: MainCollectionViewCell.toString(),
                cellType: MainCollectionViewCell.self)) { [weak self] item, model, cell in
                    guard let self = self, let model = model else { return }
                    cell.updateCell(withModel: model.item)
                    self.bindCellButtons(cell: cell, model: model)
            }.disposed(by: disposeBag)
    }
    
    private func bindCellButtons(cell: MainCollectionViewCell, model: ShopItemContainer) {
        cell.addButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.addShopItem(model.item)
            })
            .disposed(by: cell.disposeBag)
        cell.removeButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.removeShopItem(model.item)
            })
            .disposed(by: cell.disposeBag)
    }
    
    private func bindPriceOfBasket() {
        viewModel.priceOfBaket
            .subscribe(onNext: { [weak self] price in
                self?.priceLabel.text = "\(price)$"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCheckoutButton() {
        checkoutButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.router.navigate(to: .details, from: self, withParameters: self.viewModel.shopItemService)
            }
            .disposed(by: disposeBag)
    }
}
