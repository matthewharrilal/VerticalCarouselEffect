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
            cache.removeAll()
            contentHeight = 0
    
            let numberOfItems = collectionView.numberOfItems(inSection: 0)
    
            var spacing: CGFloat = 0
            var horSpacing: CGFloat = 0
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: 0)
    
    //            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    //            let itemSize = CGSize(width: UIScreen.main.bounds.width / 1.05, height: 650)
    //            let spacing: CGFloat = 0
    //            let frame = CGRect(x: 16, y: contentHeight, width: itemSize.width, height: itemSize.height)
    //
    //            attributes.frame = frame
    //            cache.append(attributes)
    //            contentHeight += frame.height + spacing
    
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let itemSize = CGSize(width: UIScreen.main.bounds.width / 1.5, height: 250)
                let xOffset: CGFloat = 16
                let frame = CGRect(x: xOffset - spacing, y: (UIScreen.main.bounds.height / 3) + spacing , width: itemSize.width, height: itemSize.height)
    
                attributes.frame = frame
                cache.append(attributes)
                contentHeight += frame.height
                spacing -= 10
            }
        }
  
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache.first { $0.indexPath == indexPath }
    }
    //
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let collectionView = collectionView else { return nil }
        
        let visibleAttributes = cache.filter { $0.frame.intersects(rect) }
        
        for attribute in visibleAttributes {
            let distanceFromCenter = abs(collectionView.bounds.midY - attribute.center.y)
            let scale = max(1 - distanceFromCenter / (collectionView.bounds.height * 2.5), 0.6) // Adjust scaling factor
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            print("The item \(attribute.indexPath.item) and it's frame \(attribute.frame)")
        }
        
        return visibleAttributes
    }
    //
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true // This ensures the layout is invalidated and recalculated on scroll
    }
}
