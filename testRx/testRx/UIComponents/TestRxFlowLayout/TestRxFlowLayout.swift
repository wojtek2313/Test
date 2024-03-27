//
//  TestRxFlowLayout.swift
//  testRx
//
//  Created by Wojciech Kulas on 23/03/2024.
//

import UIKit

// MARK: - Class Definition

open class TestRxFlowLayout: UICollectionViewFlowLayout {
    // MARK: - Private Properties
    
    private let numberOfColumns: Int
    private let customItemWidth: CGFloat?
    private let customItemHeight: CGFloat?
    
    // MARK: - Initializers
    
    public init(
        numberOfColumns: Int,
        minimumInteritemSpacing: CGFloat = 0,
        minimumLineSpacing: CGFloat = 0,
        sectionInset: UIEdgeInsets = .zero,
        customItemWidth: CGFloat?,
        customItemHeight: CGFloat?
    ) {
        self.numberOfColumns = numberOfColumns
        self.customItemWidth = customItemWidth
        self.customItemHeight = customItemHeight
        super.init()
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumLineSpacing * CGFloat(numberOfColumns - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(numberOfColumns).rounded(.down))
        itemSize = CGSize(width: customItemWidth ?? itemWidth, height: customItemHeight ?? itemWidth)
    }
    
    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        guard let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext else {
            return UICollectionViewLayoutInvalidationContext()
        }
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
