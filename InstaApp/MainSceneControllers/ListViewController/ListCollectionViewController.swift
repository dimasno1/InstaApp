//
//  ListViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class ListCollectionViewController: UIViewController {
    
    init(meta: [InstaMeta]) {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
        self.meta = meta
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        setup()
    }
    
    private func setup() {
        navigationItem.title = "List of photos"
        
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
    }
    
    private var meta: [InstaMeta] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var collectionView: UICollectionView
}

extension ListCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meta.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath)
        let photoMeta = meta[indexPath.row]
        
        if let cell = cell as? ListCollectionViewCell {
            cell.setup(with: photoMeta)
        }
        
        return cell
    }
}

extension ListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

extension ListCollectionViewCell {
    func setup(with meta: InstaMeta) {
        if let photo = meta.photo {
            setup(image: photo, captionText: meta.cellCaption, tags: meta.cellTags)
        }
    }
}

extension InstaMeta {
    var cellCaption: String {
        return caption?.text ?? "No caption"
    }
    
    var cellTags: [String] {
        return tags.isEmpty ? ["no tags provided"] : tags
    }
}
