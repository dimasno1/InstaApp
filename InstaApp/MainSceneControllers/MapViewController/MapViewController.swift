//
//  MapViewController.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//
import UIKit
import MapKit


protocol UpdateController: AnyObject {
    func updateResults(with meta: [InstaMeta])
}

class MapViewController: UIViewController {
  
    init(meta: [InstaMeta]) {
        let geoTagMeta = meta.compactMap { $0.location == nil ? nil : $0 }
        self.annotations = geoTagMeta.compactMap { $0.mapAnnotation }
        
        super.init(nibName: nil, bundle: nil)
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
        mapView.addAnnotations(annotations)
        mapView.delegate = self
        mapView.register(MapAnnotationView.self, forAnnotationViewWithReuseIdentifier: MapAnnotationView.identifier)
        
        navigationItem.title = "Photos on map"
    }
    
    private var annotations: [MKAnnotation]
    private let mapView = MKMapView()
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: MapAnnotationView.identifier, for: annotation)
        
        if let view = view as? MapAnnotationView, let annotation = annotation as? MetaMapAnnotation {
            view.annotation = annotation
            view.setup(image: annotation.photo)
        }
        
        return view
    }
}

extension MapViewController: UpdateController {

    func updateResults(with meta: [InstaMeta]) {
        let geoTagMeta = meta.compactMap { $0.location == nil ? nil : $0 }
        let new = geoTagMeta.compactMap { $0.mapAnnotation }
        
        DispatchQueue.main.async { [weak self] in
            guard let annotations = self?.annotations else {
                return
            }
            
            self?.mapView.removeAnnotations(annotations)
            self?.mapView.addAnnotations(annotations)
        }
        
        self.annotations = new
    }
}
