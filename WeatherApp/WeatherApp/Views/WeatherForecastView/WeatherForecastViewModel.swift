//
//  WeatherForecastViewModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import Foundation

struct WeatherForecastViewModel {
    struct Section {

        static var templateModel: Section {
            Section(title: "Section", rows: [.templateModel, .templateModel, .templateModel ])
        }

        let title: String?
        let rows: [WeatherForecastTableViewCellModel]
    }

    static var templateModel: WeatherForecastViewModel {
        WeatherForecastViewModel(title: "No City Name, CC",
                                 sections: [.templateModel, .templateModel, .templateModel])
    }

    let title: String?
    let sections: [Section]
}
