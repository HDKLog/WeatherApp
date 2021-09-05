//
//  WeatherAppIconsGateway.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 31.08.21.
//

import Foundation
import UIKit

typealias WeatherAppIconResult = (Result<Data, Error>) -> Void

class WeatherAppIconsGateway {
    
    func getIcon(named: String, complition: @escaping WeatherAppIconResult) {
        let query = OpenWeatherApiFileQuery(type: .x2, extention: .png).withFileName(name: named)

        let session = URLSession.shared.dataTask(with: query.getUrl()!) { data, response, error in

            DispatchQueue.main.async() {
                guard let jsonData = data, error == nil else {
                    complition(.failure(error!))
                    return
                }
                complition(.success(jsonData))
            }
        }
        session.resume()
    }
}
