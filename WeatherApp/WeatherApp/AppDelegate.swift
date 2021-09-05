//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 25.08.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        
        let router = WeatherAppRouter()
        
        let rootViewControler = WeatherDetailsViewController()
        let presenter = WeatherDetailsPresenter(view: rootViewControler, router: router)
        rootViewControler.presenter = presenter
        
        let forecastViewController = WeatherForecastViewController()
        let forecastPresenter = WeatherForecastPresenter(view: forecastViewController, router: router)
        forecastViewController.presenter = forecastPresenter
        
        router.viewControllers = [
            UINavigationController(rootViewController: rootViewControler),
            UINavigationController(rootViewController: forecastViewController)
        ]
        
        window.rootViewController = router
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }
}

