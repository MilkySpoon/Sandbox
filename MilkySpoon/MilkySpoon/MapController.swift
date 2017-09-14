//
//  MapController.swift
//  MilkySpoon
//
//  Created by 友金輝幸 on 2017/09/10.
//  Copyright © 2017年 MilkySpoon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapController: UIViewController {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    
    // おおよその位置を保持する配列
    var likelyPlaces: [GMSPlace] = []
    
    // 正確な位置情報を取得するための変数
    var selectedPlace: GMSPlace?
    
    // デフォルトの位置情報
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Google Mapの初期設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // マップの生成
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // 現在位置を取得した状態でViewに表示
        view.addSubview(mapView)
        mapView.isHidden = false
        
        listLikelyPlaces()
    
    }
    
    // おおよその位置情報の取得処理
    func listLikelyPlaces() {
        
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace { (placeLikelihoods, error) in
          
        if let error = error {
            // TODO: Handle the error.
            print("&quot;Current Place error: \(error.localizedDescription)&quot;")
            return
        }
            
        if let likelihoodList = placeLikelihoods {
            for likelihood in likelihoodList.likelihoods {
               let place = likelihood.place
                self.likelyPlaces.append(place)
               }
            }
        }
    }
}

// サンプルではこう書いてあったので、とりあえずextensionして
// 位置情報の使用許可処理と現在位置の設定処理
extension MapController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        listLikelyPlaces()
    }
    
    // 位置情報の使用許可処理
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 許可を求めるコードを記述する（後述）
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
             locationManager.startUpdatingLocation()
            break
        }
    }
    
}
