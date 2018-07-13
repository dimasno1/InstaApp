//
//  ListViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, CanBeChildViewController {
  
    init(meta: [PhotoMeta]) {
        super.init(nibName: nil, bundle: nil)
        self.meta = meta
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView = UICollectionView(frame: view.bounds)
    }
    
    private var meta: [PhotoMeta] = []
//    private var collectionView = UICollectionView()
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //FIXME: Add model
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    //FIXME: Add custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
