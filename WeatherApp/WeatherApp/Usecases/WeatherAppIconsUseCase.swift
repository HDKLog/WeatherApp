//
//  WeatherAppIconsUseCase.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 01.09.21.
//

import Foundation

typealias GeographicWeatherImageResult = (Result<Data, Error>) -> Void

class WeatherAppIconsUseCase {
    let weatherAppIconsGateway = WeatherAppIconsGateway()
    
    
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
