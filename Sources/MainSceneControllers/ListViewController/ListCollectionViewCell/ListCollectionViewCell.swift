//
//  NewListCollectionViewCell.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/24/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class ListCollectionViewCell: UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    var photo: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    var meta: InstaMeta? {
        didSet {
            updateState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(stackView)
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        header.prepareForReuseInCell()
        footer.prepareForReuseInCell()
    }

    private func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        header.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(7)
        }

        footer.snp.makeConstraints { make in
            make.height.equalTo(header)
        }
    }

    private func updateState() {
        guard let meta = meta else {
            header.prepareForReuseInCell()
            footer.prepareForReuseInCell()
            return
        }

        if let photoURL = meta.photoURL {
            ImageLoader.load(at: photoURL) { [weak self] image in
                if meta.id == self?.meta?.id {
                    self?.photo = image
                }
            }
        }

        if let pictureURL = meta.user.pictureURL {
            ImageLoader.load(at: pictureURL) { [weak self] image in
                if meta.id == self?.meta?.id {
                    self?.header.state?.image = image
                }
            }
        }

        let headerState = NewListCollectionViewHeader.State(image: nil,
                                                            username: meta.user.username,
                                                            location: meta.location?.name ?? "")
        let footerState = NewListCollectionViewFooter.State(hearthViewState: meta.userHasLiked ? .checked: .unchecked,
                                                            likesCount: String(meta.likesCount),
                                                            captionText: meta.caption?.text ?? "No text provided",
                                                            hashTags: meta.cellTags)

        header.state = headerState
        footer.state = footerState
    }

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [header, imageView, footer])
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()

    private let imageView = UIImageView()
    private let header = NewListCollectionViewHeader()
    private let footer = NewListCollectionViewFooter()
}
