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
        imageView.addSubview(tagsView)
        tagsView.addSubview(tagsTextView)
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
    
    func setup(image: UIImage, captionText: String, tags: [String]) {
        self.imageView.image = image
        self.captionTextView.text = captionText
        self.tagsTextView.text = "# \(tags.map { $0 }.joined(separator: ", "))"
    }
    
    private func setup() {
        clipsToBounds = true
        
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        tagsView.frame.size = CGSize(width: bounds.width, height: bounds.height / 4)
        tagsView.frame.origin = CGPoint(x: 0, y: bounds.maxY - tagsView.frame.size.height)
        tagsView.backgroundColor = .white
//        tagsView.layer.addSublayer(gradientLayer)
        
        tagsTextView.frame.origin = tagsView.bounds.origin.applying(CGAffineTransform(translationX: tagsView.frame.size.width / 10, y: tagsView.frame.size.height / 5))
        tagsTextView.frame.size = tagsView.frame.size.applying(CGAffineTransform(scaleX: 0.75, y: 0.8))
        tagsTextView.backgroundColor = .clear
        tagsTextView.font = UIFont.billabong
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.frame = tagsView.bounds
        gradientLayer.locations = [0.0, 0.2]
    }
    
    private let gradientLayer = CAGradientLayer()
    private let tagsView = UIView()
    private var imageView = UIImageView()
    private var captionTextView = UITextView()
    private var tagsTextView = UITextView()
}
