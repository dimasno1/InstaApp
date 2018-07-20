//
//  MapAnnotationView.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/20/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//
import MapKit

class MapAnnotationView: MKMarkerAnnotationView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: MapAnnotationView.identifier)
        
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
    }
    
    func setup(image: UIImage) {
        //        glyphImage = image
    }
    
}
