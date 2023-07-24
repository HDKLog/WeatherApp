//
//  WeatherForecastViewModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import Foundation

struct WeatherForecastViewModel {
    struct Section {
        let title: String?
        let rows: [WeatherForecastTableViewCellModel]
    }

    let title: String?
    let sections: [Section]
}

extension WeatherForecastViewModel {

    static var templateModel: WeatherForecastViewModel {
        WeatherForecastViewModel(title: "No City Name, CC",
                                 sections: [.templateModel, .templateModel, .templateModel])
    }

}

extension WeatherForecastViewModel.Section {
    static var templateModel: WeatherForecastViewModel.Section {
        WeatherForecastViewModel.Section(title: "Section", rows: [.templateModel, .templateModel, .templateModel ])
    }
}
