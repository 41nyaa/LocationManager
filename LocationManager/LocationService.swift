//
//  LocationService.swift
//  LocationManager
//
//  Created by scho on 2021/09/01.
//

import Foundation
import MapKit

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var locations: [CLLocation] = []
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 1
        manager.activityType = .fitness
        manager.requestAlwaysAuthorization()
        if !CLLocationManager.locationServicesEnabled() {
            fatalError("not support")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        self.locations = locations
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError: Error) {
        print("Error")
    }

    
    func start() {
        self.manager.startUpdatingLocation()
    }
    
    func stop() {
        self.manager.stopUpdatingLocation();
    }
    
    func request() {
        self.manager.requestLocation();
    }
}
