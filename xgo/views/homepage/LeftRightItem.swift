//
//  LeftRightItem.swift
//  swift-左右滑动CollectionView
//
//  Created by 炳神 on 16/8/7.
//  Copyright © 2016年 as2482199. All rights reserved.
//

import UIKit

class LeftRightItem: UICollectionViewFlowLayout {
    
    var selected:Int = 0
    
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: 180, height: 180)
        scrollDirection = .horizontal
        //设置内边距
        let insert : CGFloat = (collectionView!.frame.size.width - itemSize.width) / 2 
//        let insert : CGFloat = (collectionView!.frame.size.width - itemSize.width) / 2 
        sectionInset = UIEdgeInsets(top: 0, left: insert, bottom: 0, right: insert)
        minimumLineSpacing = 50
    }
}


extension LeftRightItem {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var rect : CGRect = CGRect()
        
        rect.origin.x = proposedContentOffset.x
        rect.origin.y = 0.0
        rect.size = collectionView!.frame.size

        guard let array : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) else {
            return CGPoint()
        }
    
        // 计算CollectionView最中心点的x值
        let centerX = collectionView!.frame.size.width / 2 + proposedContentOffset.x
        var minDelta : CGFloat = CGFloat(MAXFLOAT)
        for attrs : UICollectionViewLayoutAttributes in array {
            if abs(minDelta) > abs(attrs.center.x - centerX) {
                minDelta = attrs.center.x - centerX
            }
        }
        var num : CGPoint = proposedContentOffset
        num.x += minDelta
        return num
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let array = super.layoutAttributesForElements(in: rect)
        
        let centerXX = collectionView!.contentOffset.x + collectionView!.frame.size.width / 2
        
        for attrs : UICollectionViewLayoutAttributes in array! {
             //cell的中心点x 和CollectionView最中心点的x值
            let detal : CGFloat = abs(attrs.center.x - centerXX)
            //根据间距值  计算cell的缩放的比例 小于1
            let scale : CGFloat = 1 - detal / collectionView!.frame.size.width
            attrs.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return array
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
