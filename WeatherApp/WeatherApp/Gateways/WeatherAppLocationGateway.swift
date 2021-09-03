//
//  WeatherAppLocationGateway.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 03.09.21.
//

import Foundation
import CoreLocation

typealias LocationResult = (Result<CLLocationCoordinate2D, Error>) -> Void

class WeatherAppLocationGateway: NSObject, CLLocationManagerDelegate {
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    var locationRequestResult: [ LocationResult ] = []
    
    override init() {
        super.init()
    }
    
    func getCurrentLocation(complition: @escaping LocationResult) {
        
        locationRequestResult.append(complition)
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        for result in locationRequestResult {
            result(.success(locValue))
        }
        locationRequestResult.removeAll()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for result in locationRequestResult {
            result(.failure(error))
        }
        locationRequestResult.removeAll()
    }
}
