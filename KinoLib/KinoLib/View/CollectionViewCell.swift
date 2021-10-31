//
//  CollectionViewCell.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 30.10.2021.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    let title: UILabel! = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let poster: UIImageView! = {
       let imageView = UIImageView()
        imageView.image
    }()
}
