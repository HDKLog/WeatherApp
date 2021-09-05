//
//  WeatherDetailsGateway.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 31.08.21.
//

import Foundation

typealias GeographicWeatherDataResult = (Result<Data, Error>) -> Void

class WeatherDetailsGateway {
    
    lazy var requestQueue = DispatchQueue(label: "com.weatherapp.requestQueue")
    
    func getGeographicWeatherData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult) {
        
        let query = OpenWeatherApiJsonQuery(type: .Weather).withLocation(latitude: latitude, longitude: longitude).withUnits(unit: .metric)
        
        requestQueue.async {
            let session = URLSession.shared.dataTask(with: query.getUrl()!) { data, response, error in

                DispatchQueue.main.async() {
                    guard let data = data, error == nil else {
                        complition(.failure(error!))
                        return
                    }
                    complition(.success(data))
                }
            }
            session.resume()
        }
    }
    
    func getGeographicWeatherForecastData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult) {
        
        let query = OpenWeatherApiJsonQuery(type: .Forecast).withLocation(latitude: latitude, longitude: longitude).withUnits(unit: .metric)
        
        requestQueue.async {
            let session = URLSession.shared.dataTask(with: query.getUrl()!) { data, response, error in

                DispatchQueue.main.async() {
                    guard let data = data, error == nil else {
                        complition(.failure(error!))
                        return
                    }
                    complition(.success(data))
                }
            }
            session.resume()
        }
    }
}
