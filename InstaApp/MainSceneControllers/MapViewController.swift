//
//  MapViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    init(meta: [PhotoMeta]) {
        super.init(nibName: nil, bundle: nil)
        self.photosMeta = meta
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.frame = view.bounds
        
        view.addSubview(mapView)
    }

    private var photosMeta: [PhotoMeta] = []
    private let mapView = MKMapView()
}
