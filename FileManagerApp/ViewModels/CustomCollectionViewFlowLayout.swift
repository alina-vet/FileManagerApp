//
//  CustomCollectionViewFlowLayout.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 12.06.2022.
//

import UIKit

enum CollectionDisplay {
    case list
    case grid
}

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var display : CollectionDisplay = .grid {
        didSet {
            if display != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    convenience init(display: CollectionDisplay) {
        self.init()
        
        self.display = display
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.configLayout()
    }
    
    func configLayout() {
        switch display {
        case .grid:
            
            self.scrollDirection = .vertical
            if let collectionView = self.collectionView {
                let optimisedWidth = (collectionView.frame.width - minimumInteritemSpacing - 20) / 3
                self.itemSize = CGSize(width: optimisedWidth , height: optimisedWidth)
            }
            
        case .list:
            self.scrollDirection = .vertical
            if let collectionView = self.collectionView {
                self.itemSize = CGSize(width: collectionView.frame.width , height: 40)
            }
        }
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.configLayout()
    }
}
