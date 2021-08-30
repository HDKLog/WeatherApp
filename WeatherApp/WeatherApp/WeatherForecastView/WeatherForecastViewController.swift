//
//  WeatherForecastViewController.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

protocol WeatherForecastView {
    func configure(with model: WeatherForecastViewModel)
}

class WeatherForecastViewController: UITableViewController, WeatherForecastView {
    
    var presenter: WeatherForecastPresentation!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    convenience init(){
        self.init(nibName: nil, bundle: nil)
        
        setupTabBarItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        presenter?.viewDidLoad()
    }
    
    private func setupTabBarItem() {
        let icon = UIImage(named: "icon-weather-forecast")
        self.tabBarItem = UITabBarItem(title: "Forecast", image: icon, selectedImage: icon)
    }
    
    private func setupSubviews() {
        self.navigationItem.titleView = titleLabel
    }
    
    func configure(with model: WeatherForecastViewModel) {
        titleLabel.text = model.title
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }

}
