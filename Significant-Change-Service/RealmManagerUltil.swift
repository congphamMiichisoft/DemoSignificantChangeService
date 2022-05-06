//
//  RealmManager.swift
//  Significant-Change-Service
//
//  Created by Phạm Công on 05/05/2022.
//

import Foundation
import RealmSwift
import CoreLocation

class RealmManagerUltil {
    static let shared = RealmManagerUltil()
    private let realm: Realm = {
       return try! Realm()
    }()
    func saveLocation(location: LocationModel){
       try! realm.write {
            realm.add(location)
        }
    }
    
    func getLastLocation()->LocationModel?{
        let tasks = (realm.objects(LocationModel.self)).sorted(byKeyPath: "time", ascending: true)
        print(tasks.last)
        return tasks.last
    }
    
    func getListLocation()->[LocationModel]?{
        let tasks = (realm.objects(LocationModel.self))
        return tasks.sorted(by: {$0.time > $1.time})
    }
}

 class LocationModel: Object{
   @objc dynamic var lat: Double
   @objc dynamic var lon: Double
   @objc dynamic var time: Date!
     @objc dynamic var distanceMove: Double
     @objc dynamic var speed: Double
//     @objc dynamic var deltaTime: Date!
    
     required override init() {
         lat = 0
         lon = 0
         time = nil
         distanceMove = 0
         speed = 0
//         deltaTime = nil
         super.init()
     }
   convenience init(location: CLLocation) {
       self.init()
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
        self.time = location.timestamp
       self.speed = location.speed
        
    }
     
}
extension Date {
    func toString()->String{
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"

        // Convert Date to String
        return dateFormatter.string(from: self)
    }
}
