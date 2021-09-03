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
        
        let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=e9826ddefc1718ac6962acbfc2e4838e")
        
        requestQueue.async {
            let session = URLSession.shared.dataTask(with: url!) { data, response, error in

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
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=e9826ddefc1718ac6962acbfc2e4838e")
        
        requestQueue.async {
            let session = URLSession.shared.dataTask(with: url!) { data, response, error in

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
