//
//  WeatherDetailsGateway.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 31.08.21.
//

import Foundation

typealias GeographicWeatherDataResult = (Result<Data, Error>) -> Void

class WeatherDetailsGateway {
    
    let client = OpenWeatherApiClient()
    
    func getGeographicWeatherData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult) {
        
        let query = OpenWeatherApiJsonQuery(type: .weather).withLocation(latitude: latitude, longitude: longitude).withUnits(unit: .metric)
        client.getData(query: query, complition: complition)
    }
    
    func getGeographicWeatherForecastData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult) {
        
        let query = OpenWeatherApiJsonQuery(type: .forecast).withLocation(latitude: latitude, longitude: longitude).withUnits(unit: .metric)
        client.getData(query: query, complition: complition)
    }
}
