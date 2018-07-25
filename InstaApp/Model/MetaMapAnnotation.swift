//
//  MetaMapAnnotaion.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/20/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation
import MapKit

class MetaMapAnnotation: NSObject, MKAnnotation {
    
    var location: InstaMeta.Location
    var subtitle: String?
    var title: String? {
        return location.name
    }
    
    var photoURL: URL
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    init?(location: InstaMeta.Location, createdTime: String, photoURL: URL) {
        self.location = location
        self.subtitle = createdTime
        self.photoURL = photoURL
        
        super.init()
    }
    
}
