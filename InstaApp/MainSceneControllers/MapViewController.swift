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
        mapView.frame = view.bounds
        mapView.showsCompass = true
        mapView.showsScale = true
        
        view.addSubview(mapView)
    }

    private var photosMeta: [InstaMeta] = []
    private let mapView = MKMapView()
}

extension UIViewController {
    
    func deleteFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
        didMove(toParentViewController: nil)
    }
}
