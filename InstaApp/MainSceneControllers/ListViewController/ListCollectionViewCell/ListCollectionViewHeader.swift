//
//  ListCollectionViewHeader.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/24/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class NewListCollectionViewHeader: UIView {
    
    struct State {
        var image: UIImage?
        var username: String?
        var location: String?
    }
    
    var state: State? {
        didSet {
            profilePictureView.image = state?.image
            usernameTexlLabel.text = state?.username
            locationTextLabel.text = state?.location
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupViews()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureView.layer.cornerRadius = min(profilePictureView.bounds.width, profilePictureView.bounds.height) / 2
    }
    
    func prepareForReuseInCell() {
        state = State(image: nil, username: nil, location: nil)
    }
    
    private func makeConstraints() {
        let offset = 20
        
        profilePictureView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-offset * 2)
            make.width.equalTo(profilePictureView.snp.height)
            make.leading.equalToSuperview().offset(offset)
        }
        
        textViewsStack.snp.makeConstraints { make in
            make.leading.equalTo(profilePictureView.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().offset(-offset)
            make.height.equalTo(profilePictureView)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupViews() {
        usernameTexlLabel.textColor = .black
        locationTextLabel.textColor = .black
        
        profilePictureView.clipsToBounds = true
        
        textViewsStack.addArrangedSubview(usernameTexlLabel)
        textViewsStack.addArrangedSubview(locationTextLabel)
        
        addSubview(profilePictureView)
        addSubview(textViewsStack)
        
        textViewsStack.axis = .vertical
        textViewsStack.distribution = .fillEqually
    }
    
    private let usernameTexlLabel = UILabel()
    private let locationTextLabel = UILabel()
    private let profilePictureView = UIImageView()
    private let textViewsStack = UIStackView(arrangedSubviews: [])
}
