//
//  WeatherForecastTableViewCellModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 01.09.21.
//

import UIKit

struct WeatherForecastTableViewCellModel {
    
    static let reuseId = "WeatherForecastCell"
    
    struct DataRequest {
        
        typealias DataHendler = (Data) -> Void
        typealias DataRequest = (@escaping DataHendler) -> Void
        
        var requestClouser: DataRequest
        
        func requestData(handler: @escaping DataHendler) {
            requestClouser(handler)
        }
    }
    
    let image: DataRequest
    let time: String?
    let description: String?
    let temperature: String?
}
