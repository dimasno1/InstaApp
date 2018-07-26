//
//  HearthView.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/25/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class HeartView: UIView {
    
    var state: State? {
        didSet {
            imageView.image = state?.image
        }
    }
    
    enum State {
        case checked
        case unchecked
        
        var image: UIImage? {
            switch self {
            case .unchecked: return R.image.heart_uncheckedJpg()
            case .checked: return R.image.heart_checkedJpg()
            }
        }
    }
    
    init(state: State = .unchecked) {
        self.state = state
        super.init(frame: CGRect.zero)
        addSubview(imageView)
        setupImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
    }
    
    private let imageView = UIImageView()
}
