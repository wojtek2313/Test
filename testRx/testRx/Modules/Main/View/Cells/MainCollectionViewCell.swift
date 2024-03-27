//
//  MainCollectionViewCell.swift
//  testRx
//
//  Created by Wojciech Kulas on 23/03/2024.
//

import UIKit
import RxSwift
import RxRelay

class MainCollectionViewCell: UICollectionViewCell {    
    // MARK: - Public Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirHeavyOpaqueTitle
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumAvenirHeavyOpaque
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerLabel: UILabel = {
        let label = UILabel()
        label.font = .smallAvenirHeavyOpaque
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("add_button_title".localized, for: .selected)
        button.setTitle("add_button_title".localized, for: .focused)
        button.setTitle("add_button_title".localized, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        return button
    }()
    
    public let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("remove_button_title".localized, for: .selected)
        button.setTitle("remove_button_title".localized, for: .focused)
        button.setTitle("remove_button_title".localized, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifetime Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .systemGray6
        contentView.addSubviews([titleLabel, priceLabel, containerLabel, addButton, removeButton])
    }
    
    private func addConstraints() {
        /// Title Label Constraints
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: TestRxSize.sSize).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: TestRxSize.sSize).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -TestRxSize.sSize).isActive = true
        
        /// Price Label Constraints
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        /// Container Label Constraints
        containerLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true
        containerLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        containerLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        
        /// Add Button Constraints
        addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -TestRxSize.sSize).isActive = true
        addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: TestRxSize.sSize).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: TestRxSize.xlSize).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: TestRxSize.xlSize).isActive = true
        
        /// Remove Button Constraints
        removeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -TestRxSize.sSize).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -TestRxSize.sSize).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: TestRxSize.xlSize).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: TestRxSize.xlSize).isActive = true
    }
    
    // MARK: - Public Methods
    
    public func updateCell(withModel model: ShopItem) {
        titleLabel.text = model.name
        priceLabel.text = "\(model.priceInUSD)$"
        containerLabel.text = model.unitType.rawValue.uppercased()
    }
}
