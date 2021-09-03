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
        let url = URL(string:"https://openweathermap.org/img/wn/\(named)@2x.png")

        let session = URLSession.shared.dataTask(with: url!) { data, response, error in

            DispatchQueue.main.async() {
                guard let jsonData = data, error == nil else {
                    complition(.failure(error!))
                    return
                }
                complition(.success(jsonData))
            }
        }
        session.resume()
//        let image = #imageLiteral(resourceName: "04d@2x.png")
//
//        complition(.success(image.pngData()!))
    }
}
