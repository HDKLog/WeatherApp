//
//  WeatherAppGateway.swift
//  WeatherApp
//
//  Created by Gari Sarkisyan on 04.07.23.
//

import Foundation
import CoreLocation

typealias WeatherAppIconResult = (Result<Data, Error>) -> Void
typealias GeographicWeatherDataResult = (Result<Data, Error>) -> Void
typealias LocationResult = (Result<CLLocationCoordinate2D, Error>) -> Void

protocol WeatherAppGateway {

    func getGeographicWeatherData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult)
    func getGeographicWeatherForecastData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult)
    func getIcon(named: String, complition: @escaping WeatherAppIconResult)
    func getCurrentLocation(complition: @escaping LocationResult)
}

class WeatherAppGatewayClient: NSObject, WeatherAppGateway {

    let client = OpenWeatherApiClient()

    var locationRequestResult: [ LocationResult ] = []

    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return locationManager
    }()

    override init() {
        super.init()
    }
    

    func getGeographicWeatherData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult) {

        let query = OpenWeatherApiJsonQuery(type: .weather).withLocation(latitude: latitude, longitude: longitude).withUnits(unit: .metric)
        client.getData(query: query, complition: complition)
    }

    func getGeographicWeatherForecastData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult) {

        let query = OpenWeatherApiJsonQuery(type: .forecast).withLocation(latitude: latitude, longitude: longitude).withUnits(unit: .metric)
        client.getData(query: query, complition: complition)
    }

    func getIcon(named: String, complition: @escaping WeatherAppIconResult) {
        let query = OpenWeatherApiFileQuery(type: .x2, extention: .png).withFileName(name: named)

        client.getData(query: query, complition: complition)
    }

    func getCurrentLocation(complition: @escaping LocationResult) {
        
        locationRequestResult.append(complition)
        locationManager.requestWhenInUseAuthorization()
        if [CLAuthorizationStatus.authorizedAlways, CLAuthorizationStatus.authorizedWhenInUse].contains(CLLocationManager.authorizationStatus()) {
            locationManager.stopUpdatingLocation()
            locationManager.startUpdatingLocation()
        }
    }
}

extension WeatherAppGatewayClient: CLLocationManagerDelegate {
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

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        let locationDenied = NSError(domain: "com.weatherApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Please allow location service to get local weather"])

        if [CLAuthorizationStatus.authorizedAlways, CLAuthorizationStatus.authorizedWhenInUse].contains(CLLocationManager.authorizationStatus()) {
            locationManager.stopUpdatingLocation()
            locationManager.startUpdatingLocation()
        } else if [CLAuthorizationStatus.denied, CLAuthorizationStatus.restricted].contains(CLLocationManager.authorizationStatus()) {
            for result in locationRequestResult {
                result(.failure(locationDenied))
            }
            locationRequestResult.removeAll()
        }
    }
}
