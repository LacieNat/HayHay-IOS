//
//  User.swift
//  HayHay
//
//  Created by Lacie on 4/7/16.
//  Copyright © 2016 Lacie. All rights reserved.
//

import UIKit
import MapKit

class User: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String?
    
    init(title: String?, coordinate: CLLocationCoordinate2D, info: String?) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
