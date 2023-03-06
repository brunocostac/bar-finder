//
//  UIHelper.swift
//  bar-finder
//
//  Created by Bruno Costa on 15/02/23.
//

import UIKit

enum UIHelper {
    
    static func makeFourColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let screenWidth = view.bounds.width
        let spacing: CGFloat = 10.0
        let itemWidth: CGFloat = (screenWidth - spacing * 5) / 4
        let itemHeight = itemWidth + 40 
        
        let layout: UICollectionViewFlowLayout = .init()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return layout
    }
}
