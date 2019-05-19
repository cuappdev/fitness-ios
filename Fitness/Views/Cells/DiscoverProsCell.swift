//
//  ProCell.swift
//  Fitness
//
//  Created by Cameron Hamidi on 4/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class DiscoverProsCell: UICollectionViewCell {
    
    // MARK: - INITIALIZATION
    static let identifier = Identifiers.discoverProsCell
    var collectionView: UICollectionView!
    let itemSize = CGSize(width: 228.0, height: 195.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // COLLECTION VIEW LAYOUT
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.itemSize = itemSize
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delaysContentTouches = false
        collectionView.accessibilityIdentifier = Identifiers.discoverProsCell
        collectionView.register(ProCollectionViewCell.self, forCellWithReuseIdentifier: ProCollectionViewCell.identifier)
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
