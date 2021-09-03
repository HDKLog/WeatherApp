//
//  WeatherForecastUseCase.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 31.08.21.
//

import Foundation

typealias GeographicWeatherForecastResult = (Result<GeographicWeatherForecast, Error>) -> Void

class WeatherForecastUseCase {
    
    let weatherDetailsGateway = WeatherDetailsGateway()
    
    func getGeographicWeather(for coordinates: GeographicLocation, completion: @escaping GeographicWeatherForecastResult) {
        
        weatherDetailsGateway.getGeographicWeatherForecastData(latitude: coordinates.latitude, longitude: coordinates.longitude) { result in
            switch result {
            case .success(let jsonData):
                guard let model = try? JSONDecoder().decode(GeographicWeatherForecast.self, from: jsonData) else {
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
