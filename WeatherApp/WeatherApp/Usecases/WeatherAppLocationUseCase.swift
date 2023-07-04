//
//  WeatherAppLocationUseCase.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 03.09.21.
//

import Foundation

typealias GeographicLocationResult = (Result<GeographicLocation, Error>) -> Void
typealias GeographicWeatherIconResult = (Result<Data, Error>) -> Void
typealias GeographicWeatherForecastResult = (Result<GeographicWeatherForecast, Error>) -> Void
typealias GeographicWeatherResult = (Result<GeographicWeather, Error>) -> Void

protocol WeatherAppUseableCase {
    func getGeographicWeatherForecast(for coordinates: GeographicLocation, completion: @escaping GeographicWeatherForecastResult)
    func getGeographicWeather(for coordinates: GeographicLocation, completion: @escaping GeographicWeatherResult)
    func getCurrentLocation(completion: @escaping GeographicLocationResult)
    func getIcon(named: String, completion: @escaping GeographicWeatherIconResult)
}

class WeatherAppUseCase: WeatherAppUseableCase {

    static let parsingError = NSError(domain: "com.weatherApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fail to get consistent responce from server"])

    let gateway: WeatherAppGateway!

    init(gateway: WeatherAppGateway) {
        self.gateway = gateway
    }

    func getGeographicWeatherForecast(for coordinates: GeographicLocation, completion: @escaping GeographicWeatherForecastResult) {

        gateway.getGeographicWeatherForecastData(latitude: coordinates.latitude, longitude: coordinates.longitude) { result in
            switch result {
            case .success(let jsonData):
                guard let model = try? JSONDecoder().decode(GeographicWeatherForecast.self, from: jsonData) else {
                    completion(.failure(WeatherAppUseCase.parsingError))
                    return
                }
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getGeographicWeather(for coordinates: GeographicLocation, completion: @escaping GeographicWeatherResult) {

        gateway.getGeographicWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude) { result in
            switch result {
            case .success(let jsonData):

                guard let model = try? JSONDecoder().decode(GeographicWeather.self, from: jsonData) else {
                    completion(.failure(WeatherAppUseCase.parsingError))
                    return
                }

                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getCurrentLocation(completion: @escaping GeographicLocationResult) {
        gateway.getCurrentLocation { result in
            switch result {
            case .success(let location):
                completion(.success(GeographicLocation(latitude: location.latitude, longitude: location.longitude)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getIcon(named: String, completion: @escaping GeographicWeatherIconResult) {

        gateway.getIcon(named: named) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
