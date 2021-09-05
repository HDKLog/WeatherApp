//
//  WeatherAppRouter.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

protocol WeatherAppRoutering {
    func rootTo(tab index: Int)
}

class WeatherAppRouter: UITabBarController, WeatherAppRoutering {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func rootTo(tab index: Int) {
        self.selectedIndex = index
    }

}
