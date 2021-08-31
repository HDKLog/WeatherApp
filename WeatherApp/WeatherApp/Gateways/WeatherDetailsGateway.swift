//
//  WeatherDetailsGateway.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 31.08.21.
//

import Foundation

typealias GeographicWeatherDataResult = (Result<Data, Error>) -> Void

class WeatherDetailsGateway {
    
    func getGeographicWeatherData(latitude: Double, longitude: Double, complition: @escaping GeographicWeatherDataResult) {
        
//        let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=e9826ddefc1718ac6962acbfc2e4838e")
//
//        let session = URLSession.shared.dataTask(with: url!) { data, response, error in
//
//            DispatchQueue.main.async() {
//                guard let data = data, error == nil else {
//                    complition(.failure(error!))
//                    return
//                }
//                complition(.success(data))
//            }
//        }
//        session.resume()
        
        let jsonString = "{\"coord\":{\"lon\":44.8306,\"lat\":41.695},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03n\"}],\"base\":\"stations\",\"main\":{\"temp\":26.94,\"feels_like\":27.36,\"temp_min\":26.94,\"temp_max\":26.94,\"pressure\":1014,\"humidity\":50},\"visibility\":10000,\"wind\":{\"speed\":2.57,\"deg\":70},\"clouds\":{\"all\":40},\"dt\":1630355526,\"sys\":{\"type\":1,\"id\":8862,\"country\":\"GE\",\"sunrise\":1630376740,\"sunset\":1630424208},\"timezone\":14400,\"id\":611717,\"name\":\"Tbilisi\",\"cod\":200}"
        complition(.success(jsonString.data(using: .utf8)!))
    }
}
