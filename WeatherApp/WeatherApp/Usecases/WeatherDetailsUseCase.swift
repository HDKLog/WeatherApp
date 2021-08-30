//
//  WeatherDetailsUseCase.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import Foundation

typealias GeographicWeatherResult = (Result<GeographicWeather, Error>) -> Void
typealias GeographicWeatherImageResult = (Result<Data, Error>) -> Void

class WeatherDetailsUseCase {
    
    let weatherDetailsGateway = WeatherDetailsGateway()
    let weatherAppIconsGateway = WeatherAppIconsGateway()
    
    func getGeographicWeather(for coordinates: GeographicWeather.Coordinates, completionHandler: @escaping GeographicWeatherResult) {
        
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
    
    func getIcon(named: String, complition: @escaping GeographicWeatherImageResult) {
        
        weatherAppIconsGateway.getIcon(named: named) { result in
            switch result {
            case .success(let data):
                complition(.success(data))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}
