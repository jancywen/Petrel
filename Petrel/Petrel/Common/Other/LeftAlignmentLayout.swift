//
//  LeftAlignmentLayout.swift
//  Petrel
//
//  Created by wangwenjie on 2020/1/2.
//  Copyright © 2020 Petrel. All rights reserved.
//

import Foundation

/// 商品SKU的横向布局
public class LeftAlignmentLayout: UICollectionViewFlowLayout {
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let answer = super.layoutAttributesForElements(in: rect)
        
        answer?.enumerated().forEach({ (index, attribute) in
            guard answer != nil else { return }
            guard index > 0 else { return }
            let last = answer![index - 1]
            let origin = last.frame.maxX
            let margin = self.minimumInteritemSpacing
            // 在同一行，小于contentsize
            if attribute.frame.origin.y == last.frame.origin.y,
                origin + attribute.bounds.width + margin - sectionInset.left - sectionInset.right < collectionViewContentSize.width {
                
                var frame = attribute.frame
                frame.origin.x = origin + margin
                attribute.frame = frame
            }
        })
        
        return answer
    }
}
