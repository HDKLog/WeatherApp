//
//  WeatherDetailsUseCase.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import Foundation

typealias GeographicWeatherResult = (Result<GeographicWeather, Error>) -> Void

class WeatherDetailsUseCase {
    
    let weatherDetailsGateway = WeatherDetailsGateway()
    
    func getGeographicWeather(for coordinates: GeographicLocation, completionHandler: @escaping GeographicWeatherResult) {
        
        weatherDetailsGateway.getGeographicWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude) { result in
            switch result {
            case .success(let jsonData):
                let model = try! JSONDecoder().decode(GeographicWeather.self, from: jsonData)
                completionHandler(.success(model))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
