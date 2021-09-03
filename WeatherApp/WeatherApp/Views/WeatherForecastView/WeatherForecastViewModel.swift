//
//  WeatherForecastViewModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import Foundation

struct WeatherForecastViewModel {
    struct Section {
        let title: String
        let rows: [WeatherForecastTableViewCellModel]
    }
    let title: String?
    let sections: [Section]
}
