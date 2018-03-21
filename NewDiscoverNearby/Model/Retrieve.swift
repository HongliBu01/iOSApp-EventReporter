//
//  Retrieve.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/16/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import Foundation
import CoreLocation
import GeoFire

/**
    define data structure that fetched from firebase
 */
class Retrieve {
    var caption: String?
    var photoUrl: String?
    var uid: String?
    var lat: Double?
    var lon: Double?
    var description: String?
}


/**
    connect to interface to home view for retrieving data
 */
extension Retrieve {
    static func transformPostPhoto(dict: [String: Any]) -> Retrieve {
        let post = Retrieve()
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.lat = dict["lat"] as? Double
        post.lon = dict["lon"] as? Double
        post.description = dict["description"] as? String
        return post
    }
}
