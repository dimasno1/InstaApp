//
//  ListCollectionViewFooter.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/24/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class NewListCollectionViewFooter: UIView {

    var state: State? {
        didSet {
            heartView.state = state?.hearthViewState
            likesCounterLabel.text = state?.likesCount
            captionTextLabel.text = state?.captionText
            hashtagsLabel.text = state?.hashTags.map { $0 }?.joined(separator: ", ")
        }
    }

    struct State {
        let hearthViewState: HeartView.State
        let likesCount: String?
        let captionText: String?
        let hashTags: [String]?
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(viewsStackView)
        addSubview(labelsStackView)

        setup()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        likesCounterLabel.layoutIfNeeded()
        likesCounterLabel.layer.cornerRadius = min(likesCounterLabel.bounds.width, likesCounterLabel.bounds.height) / 2
    }

    func prepareForReuseInCell() {
        state = State(hearthViewState: .unchecked, likesCount: nil, captionText: nil, hashTags: nil)
    }

    private func makeConstraints() {
        let offset = 10

        viewsStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(offset)
            make.height.equalToSuperview().offset(-offset * 2)
            make.centerY.equalToSuperview()
            make.width.equalTo(viewsStackView.snp.height).dividedBy(2)
        }

        labelsStackView.snp.makeConstraints { make in
            make.leading.equalTo(viewsStackView.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().offset(-offset)
            make.top.equalTo(viewsStackView)
            make.bottom.equalTo(viewsStackView)
        }
    }

    private func setup() {
        likesCounterLabel.textAlignment = .center
        likesCounterLabel.layer.backgroundColor = UIColor.lightGray.cgColor
        likesCounterLabel.textColor = .white
        likesCounterLabel.font = UIFont.boldSystemFont(ofSize: 11)
    }

    private lazy var viewsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heartView, likesCounterLabel])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()

    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [captionTextLabel, hashtagsLabel])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()

    private let heartView = HeartView()
    private let likesCounterLabel = UILabel()
    private let captionTextLabel = UILabel()
    private let hashtagsLabel = UILabel()
}
