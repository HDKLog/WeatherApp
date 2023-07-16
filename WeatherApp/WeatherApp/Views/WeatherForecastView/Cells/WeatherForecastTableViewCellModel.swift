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
    
    let iconName: String?
    let iconLoader: WeatherForecastTableViewCellIconDataLoader?
    let time: String?
    let description: String?
    let temperature: String?
}
