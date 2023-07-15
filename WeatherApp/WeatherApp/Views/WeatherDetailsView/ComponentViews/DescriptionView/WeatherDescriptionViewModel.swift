//
//  WeatherDescriptionViewModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

struct WeatherDescriptionViewModel {
    
    struct DataRequest {
        
        typealias DataHendler = (Data) -> Void
        typealias DataRequest = (@escaping DataHendler) -> Void
        
        var requestClouser: DataRequest
        
        func requestData(handler: @escaping DataHendler) {
            requestClouser(handler)
        }
    }

    struct WeatherDescription: CustomStringConvertible {
        enum TemperatureUnit: String {
            case celsius = "C"
            case fahrenheit = "F"
        }

        let temperature: Int
        let temperatureUnit: TemperatureUnit
        let details: String?

        var description: String { "\(temperature)°\(temperatureUnit.rawValue) \(details.flatMap { " | " + $0 } ?? "" )" }
    }
    
    let weatherImage: DataRequest?
    let locationDescription: String?
    let weatherDescription: WeatherDescription?
}
