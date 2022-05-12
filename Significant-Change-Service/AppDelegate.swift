//
//  AppDelegate.swift
//  Significant-Change-Service
//
//  Created by Phạm Công on 05/05/2022.
//

import UIKit
import CoreLocation
import UserNotifications
import GoogleMaps


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var locationManager: CLLocationManager!
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configLocationManager()
        configMap()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, err) in
                print("granted: (\(granted)")
            }
        UNUserNotificationCenter.current().delegate = self
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        let navi = UINavigationController(rootViewController: vc)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        return true
    }
    

    func configLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
        LocationManagerUltil.shared.locationManager = locationManager
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                startMonitoring()
                break;
            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func startMonitoring(){
//        locationManager.startUpdatingLocation()
//        startMySignificantLocationChanges()
        locationManager.startMonitoringVisits()
    }
    
    func configMap(){
        GMSServices.provideAPIKey("AIzaSyBrykI-fcRWjIkkaSZmNWvwg8zbGz1x3Nc")
    }


}
extension AppDelegate: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startMonitoring()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            LocationManagerUltil.shared.handleLocation(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(region)
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(region)
    }
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
