//
//  DetailsViewController.swift
//  testRx
//
//  Created by Wojciech Kulas on 26/03/2024.
//

import UIKit
import RxSwift
import RxDataSources

class DetailsViewController: UIViewController {
    // MARK: - Private Properties
    
    private var viewModel: DetailsViewModel
    private var disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        let cellReuseIdentifier = String(describing: CurrencyTableViewCell.self)
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var bottomTabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupPriceLabelData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifetime Methods

    override func loadView() {
        super.loadView()
        addSubviews()
        addConstraints()
        setupObservers()
    }
    
    // MARK: - Private Methods
    
    private func setupPriceLabelData() {
        priceLabel.text = "\(viewModel.basketPriceInUSD)$"
    }
    
    private func addSubviews() {
        self.view.backgroundColor = .white
        view.addSubviews([tableView, bottomTabBarView])
        bottomTabBarView.addSubviews([priceLabel])
    }
    
    private func addConstraints() {
        /// Table View Constraints
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomTabBarView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        /// Bottom Tab Bar View Constraints
        bottomTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: TestRxSize.zero).isActive = true
        bottomTabBarView.heightAnchor.constraint(equalToConstant: TestRxSize.large).isActive = true
        bottomTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TestRxSize.zero).isActive = true
        bottomTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: TestRxSize.zero).isActive = true
        
        /// Price Label Constraints
        priceLabel.trailingAnchor.constraint(equalTo: bottomTabBarView.trailingAnchor, constant: -TestRxSize.sSize).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: bottomTabBarView.centerYAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: TestRxSize.large).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: TestRxSize.largeSize).isActive = true
    }
}

// MARK: - Setup Observers

extension DetailsViewController {
    private func setupObservers() {
        bindTableView()
    }
    
    private func bindTableView() {
        viewModel.basketPrices
            .bind(to:tableView.rx.items(
                cellIdentifier: CurrencyTableViewCell.toString(),
                cellType: CurrencyTableViewCell.self)
            ) { [weak self] row, item, cell in
                guard let self = self else { return }
                cell.updateCell(dollarValue: self.viewModel.basketPriceInUSD, currency: item)
        }.disposed(by: disposeBag)
    }
}
