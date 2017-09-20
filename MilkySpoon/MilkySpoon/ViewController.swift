//
//  ViewController.swift
//  MilkySpoon
//
//  Created by MilkySpoon on 2017/09/08.
//  Copyright © 2017年 MilkySpoon. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    var latituide = -33.86
    var longtitude = 151.20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        // maker
        let maker      = GMSMarker()
        maker.position = CLLocationCoordinate2D(latitude: self.latituide, longitude: self.longtitude)
        maker.title    = "Title"
        maker.snippet  = "Australia"
        maker.map      = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

