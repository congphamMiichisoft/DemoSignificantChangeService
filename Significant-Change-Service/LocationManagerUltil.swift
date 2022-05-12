//
//  LocationManagerUltil.swift
//  Significant-Change-Service
//
//  Created by Phạm Công on 05/05/2022.
//

import Foundation
import CoreLocation
import UserNotifications

class LocationManagerUltil {
    var locationManager: CLLocationManager!
    static let shared = LocationManagerUltil()
    
    init(){
        
    }
 
    
    func handleLocation(location: CLLocation){
        let locationModel = LocationModel(location: location)
        if let lastLocation = RealmManagerUltil.shared.getLastLocation() {
            let loc = CLLocation(latitude: CLLocationDegrees(lastLocation.lat), longitude: CLLocationDegrees(lastLocation.lon))
            let distance = loc.distance(from: location)
            locationModel.distanceMove = distance
        }
        
        RealmManagerUltil.shared.saveLocation(location: locationModel)
        sendNoti(location: locationModel)
    }
    
    func sendNoti(location: LocationModel){
        let content = UNMutableNotificationContent()
        content.title = "\(location.lat) - \(location.lon)"
        content.body = "\(location.time.toString()) - \(location.distanceMove) Speed: \(location.speed)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


