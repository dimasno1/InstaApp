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
    
    init(meta: [InstaMeta]) {
        super.init(nibName: nil, bundle: nil)
        
        self.photosMeta = meta
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        
        view.addSubview(mapView)
    }
    
    private func setup() {
        mapView.frame = view.bounds
        mapView.showsCompass = true
        mapView.showsScale = true
       
        navigationItem.title = "Photos on map"
    }
    
    private var locationCoordinates: [CLLocationCoordinate2D] {
        return photosMeta.compactMap { $0.locationCoordinate }
    }
    
    private let mapView = MKMapView()
    private var photosMeta: [InstaMeta] = []
}
