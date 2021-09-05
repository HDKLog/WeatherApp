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
    
    let client = OpenWeatherApiClient()
    
    func getIcon(named: String, complition: @escaping WeatherAppIconResult) {
        let query = OpenWeatherApiFileQuery(type: .x2, extention: .png).withFileName(name: named)

        client.getData(query: query, complition: complition)
    }
}
