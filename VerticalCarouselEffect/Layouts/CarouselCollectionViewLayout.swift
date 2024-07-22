//
//  CarouselCollectionViewLayout.swift
//  VerticalCarouselEffect
//
//  Created by Space Wizard on 7/22/24.
//

import Foundation
import UIKit

class CarouselCollectionViewLayout: UICollectionViewLayout {
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }

        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 250)
            let spacing: CGFloat = 25
            let frame = CGRect(x: UIScreen.main.bounds.midX / 2, y: contentHeight + spacing, width: itemSize.width, height: itemSize.height)

            attributes.frame = frame
            cache.append(attributes)
            contentHeight += frame.height + spacing
        }
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache.first { $0.indexPath == indexPath }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { $0.frame.intersects(rect) }
    }
}
