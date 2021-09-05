//
//  OpenWeatherApiClient.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 05.09.21.
//

import Foundation

typealias OpenWeatherApiQueryResult = (Result<Data, Error>) -> Void

class OpenWeatherApiClient {
    
    static let queryError = NSError(domain: "com.weatherApp", code: 3, userInfo: [NSLocalizedDescriptionKey: "Fail to get URL from Query"])
    
    let sesssion: URLSession = URLSession.shared
    
    func getData(query: OpenWeatherApiQuery, complition: @escaping OpenWeatherApiQueryResult) {
        
        guard let url = query.getUrl() else {
            DispatchQueue.main.async() {
                complition(.failure(OpenWeatherApiClient.queryError))
            }
            return
        }
        
        let task = sesssion.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async() {
                guard let jsonData = data, error == nil else {
                    complition(.failure(error!))
                    return
                }
                complition(.success(jsonData))
            }
        }
        task.resume()
    }
}
