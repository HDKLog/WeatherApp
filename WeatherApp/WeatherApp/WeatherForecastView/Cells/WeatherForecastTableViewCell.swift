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
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = DesignBook.Color.Foreground.highlited.uiColor()
        
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        contentView.backgroundColor = DesignBook.Color.Background.list.uiColor()
        setupSubvies()
    }
    
    func setupSubvies() {
        contentView.addSubview(weatherImageView)
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            weatherImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            weatherImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            weatherImageView.heightAnchor.constraint(equalToConstant: 48),
            weatherImageView.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 6),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 6),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        contentView.addSubview(temperatureLabel)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(with model: WeatherForecastTableViewCellModel) {
        model.image.requestData { [weak self] data in
            self?.weatherImageView.image = UIImage(data: data)
        }
        timeLabel.text = model.time
        descriptionLabel.text = model.description
        temperatureLabel.text = model.temperature
    }
    
}
