//
//  WeatherDetailsUseCase.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import Foundation

typealias GeographicWeatherResult = (Result<GeographicWeather, Error>) -> Void

class WeatherDetailsUseCase {
    
    static let parsingError = NSError(domain: "com.weatherApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fail to get consistent responce from server"])
    
    let weatherDetailsGateway = WeatherDetailsGateway()
    
    func getGeographicWeather(for coordinates: GeographicLocation, completion: @escaping GeographicWeatherResult) {
        
        weatherDetailsGateway.getGeographicWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude) { result in
            switch result {
            case .success(let jsonData):
                
                guard let model = try? JSONDecoder().decode(GeographicWeather.self, from: jsonData) else {
                    completion(.failure(WeatherDetailsUseCase.parsingError))
                    return
                }
                
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
