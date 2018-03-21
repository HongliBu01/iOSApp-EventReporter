//
//  MapAnnotation.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/16/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit
import MapKit

/**
    define annotation message of map
 */

class MapAnnotation: NSObject, MKAnnotation{
    let title: String?
    let textBody: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, textBody:String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.textBody = textBody
        self.coordinate = coordinate
    }
}
