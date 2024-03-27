//
//  CurrencyTableViewCell.swift
//  testRx
//
//  Created by Wojciech Kulas on 26/03/2024.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    // MARK: - UI
    
    private var currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(currencyLabel)
    }
    
    private func addConstraints() {
        currencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -TestRxSize.sSize).isActive = true
        currencyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TestRxSize.sSize).isActive = true
        currencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TestRxSize.sSize).isActive = true
        currencyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TestRxSize.sSize).isActive = true
    }
    
    // MARK: - Public Methods
    
    public func updateCell(dollarValue: Double, currency: String) {
        currencyLabel.text = "\(dollarValue)$ : \(currency)"
        self.selectionStyle = .none
    }
}
