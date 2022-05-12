//
//  MapViewController.swift
//  Significant-Change-Service
//
//  Created by Miichi on 5/6/22.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var mapView: GMSMapView?
    var listLocation: [LocationModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        configMap()
        if listLocation == nil {
            getData()
        }else {
            drawPin(location: listLocation!)
        }
        
    }
    
    func initData(listLocation: [LocationModel]?) {
        self.listLocation = listLocation
    }
    
    func getData(){
        guard let listLocation = RealmManagerUltil.shared.getListLocation() else {return}
        
//        drawLine(location: listLocation)
        drawPin(location: listLocation)
    }
    
    func configMap(){
        let current = LocationManagerUltil.shared.locationManager.location
        let camera = GMSCameraPosition.camera(withLatitude: current?.coordinate.latitude ?? 0, longitude: current?.coordinate.longitude ?? 0, zoom: 16.0)
         mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView?.isMyLocationEnabled = true
        mapView?.isTrafficEnabled = true
        self.view.addSubview(mapView!)
        mapView?.isIndoorEnabled = true
        
        
    }
    
    func drawLine(location: [LocationModel]){
        let path = GMSMutablePath()
        
        location.forEach { locationModel in
            path.add(CLLocationCoordinate2D(latitude: locationModel.lat, longitude: locationModel.lon))
        }

            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .blue
            polyline.strokeWidth = 2.0
            polyline.map = mapView
    }
    
    func drawPin(location: [LocationModel]){
        location.forEach { locationModel in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: locationModel.lat, longitude: locationModel.lon)
            marker.title = locationModel.time.toString()
//            marker.snippet = "Australia"
            marker.map = mapView
        }
        
    }
    
}
