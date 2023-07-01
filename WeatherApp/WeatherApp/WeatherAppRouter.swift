//
//  WeatherAppRouter.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

enum WeatherAppRouteringTab: Int {
    case details
    case forecast
}

protocol WeatherAppRoutering {
    func rootTo(tab index: WeatherAppRouteringTab)
}

class WeatherAppRouter: UITabBarController, WeatherAppRoutering {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func rootTo(tab index: WeatherAppRouteringTab) {
        self.selectedIndex = index.rawValue
    }

}
