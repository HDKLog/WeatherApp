//
//  WeatherAppLocationUseCase.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 03.09.21.
//

import Foundation

typealias GeographicLocationResult = (Result<GeographicLocation, Error>) -> Void

class WeatherAppLocationUseCase {
    
    let gateway = WeatherAppLocationGateway()
    
    func getCurrentLocation(complition: @escaping GeographicLocationResult) {
        gateway.getCurrentLocation { result in
            switch result {
            case .success(let location):
                complition(.success(GeographicLocation(latitude: location.latitude, longitude: location.longitude)))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}
