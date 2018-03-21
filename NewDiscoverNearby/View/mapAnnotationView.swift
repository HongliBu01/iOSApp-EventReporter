//
//  mapAnnotationView.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/17/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit
import MapKit

/**
 Define Annotation view for map annotation
 */
class mapAnnotationView: MKMarkerAnnotationView {
    /**
        initialize annotation view, define CalloutAccessoryView, use label to show event infomation
    */
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let newAnnotation = newValue as? MapAnnotation else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "LocationIcon"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton
            markerTintColor = .blue
            glyphText = "❤︎"
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = newAnnotation.textBody
            detailCalloutAccessoryView = detailLabel
        }
    }

}
