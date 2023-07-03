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
    
    let weatherImage: DataRequest?
    let locationDescription: String?
    let weatherDescription: String?
}
