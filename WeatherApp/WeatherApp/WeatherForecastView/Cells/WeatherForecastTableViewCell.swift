//
//  WeatherForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    
    let weatherImageView = UIImageView()
    let timeLabel = UILabel()
    let descriptionLabel = UILabel()
    let temperatureLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
