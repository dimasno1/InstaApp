//
//  NewListCollectionViewCell.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/24/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class NewListCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        self.imageView = UIImageView(frame: frame)
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setup(with image: UIImage) {
        self.imageView.image = image
    }
    
    private let imageView: UIImageView
}
