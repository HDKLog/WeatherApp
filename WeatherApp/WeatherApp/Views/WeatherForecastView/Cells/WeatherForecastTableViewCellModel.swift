//
//  WeatherForecastTableViewCellModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 01.09.21.
//

import UIKit

protocol WeatherForecastTableViewCellIconDataLoader {
    func loadDataForIcon(named name: String?, complition: @escaping ((Data) -> Void))
}

struct WeatherForecastTableViewCellModel {
    
    static let reuseId = "WeatherForecastCell"

    static var templateModel: WeatherForecastTableViewCellModel {
        WeatherForecastTableViewCellModel(
            iconName: "001",
            iconLoader: nil,
            time: "12:00",
            description: "some description",
            temperature: "00"
        )
    }
    
    let iconName: String?
    let iconLoader: WeatherForecastTableViewCellIconDataLoader?
    let time: String?
    let description: String?
    let temperature: String?
}
