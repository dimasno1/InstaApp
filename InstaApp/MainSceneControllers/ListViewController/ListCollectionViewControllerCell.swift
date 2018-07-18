//
//  ListViewControllerCell.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/16/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        captionTextView.text = nil
        tagsTextView.text = nil
    }
    
    func setupCell(image: UIImage, caption: InstaMeta.Caption, tags: [String]) {
        self.imageView.image = image
        self.captionTextView.text = caption.text
        self.tagsTextView.text = "#\(tags.map { $0 }.joined())"
    }
    
    private func setup() {
        clipsToBounds = true
        
        imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.size.width, height: bounds.size.height * 3 / 4))
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFill
    }
    
    private var imageView = UIImageView()
    private var captionTextView = UITextView()
    private var tagsTextView = UITextView()
}
