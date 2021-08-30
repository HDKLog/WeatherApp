//
//  WeatherDescriptionView.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

class WeatherDescriptionView: UIView {
    
    let weatherImage = UIImageView()
    let locationDescriptionLabel = UILabel()
    let weatherDescriptionLabel = UILabel()
    
    var portraitLayoutConstraints: [NSLayoutConstraint] = []
    var landscapeLayoutConstraints: [NSLayoutConstraint] = []

    convenience init() {
        self.init(frame: .zero)
        setupSubViews()
    }
    
    private func setupSubViews() {
        
        setupWeatherImageView()
        setupLocationDescriptionLabel()
        setupWeatherDescriptionLabel()
        NSLayoutConstraint.activate(landscapeLayoutConstraints)
    }
    
    private func setupWeatherImageView() {
        self.addSubview(weatherImage)
        //weatherImage.backgroundColor = .cyan
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        
        let portraitConstraints = [
            weatherImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -100),
            weatherImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 64),
            weatherImage.heightAnchor.constraint(equalToConstant: 64),
        ]
        portraitLayoutConstraints.append(contentsOf: portraitConstraints)
        
        let landscapeConstraints = [
            weatherImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImage.centerXAnchor.constraint(greaterThanOrEqualTo: centerXAnchor, constant: -64),
            weatherImage.widthAnchor.constraint(equalToConstant: 64),
            weatherImage.heightAnchor.constraint(equalToConstant: 64),
        ]
        landscapeLayoutConstraints.append(contentsOf: landscapeConstraints)
    }
    
    private func setupLocationDescriptionLabel() {
        self.addSubview(locationDescriptionLabel)
        locationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let portraitConstraints = [
            locationDescriptionLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 12),
            locationDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        portraitLayoutConstraints.append(contentsOf: portraitConstraints)
        
        let landscapeConstraints = [
            locationDescriptionLabel.topAnchor.constraint(equalTo: weatherImage.topAnchor),
            locationDescriptionLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 6),
        ]
        landscapeLayoutConstraints.append(contentsOf: landscapeConstraints)
    }
    
    private func setupWeatherDescriptionLabel() {
        self.addSubview(weatherDescriptionLabel)
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let portraitConstraints = [
            weatherDescriptionLabel.topAnchor.constraint(equalTo: locationDescriptionLabel.bottomAnchor, constant: 12),
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        portraitLayoutConstraints.append(contentsOf: portraitConstraints)
        
        let landscapeConstraints = [
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 6),
            weatherDescriptionLabel.topAnchor.constraint(equalTo: locationDescriptionLabel.bottomAnchor, constant: 12),
        ]
        landscapeLayoutConstraints.append(contentsOf: landscapeConstraints)
    }
    
    func configure(with model:WeatherDescriptionViewModel) {
        weatherImage.image = model.weatherImage
        locationDescriptionLabel.text = model.locationDescription
        weatherDescriptionLabel.text = model.weatherDescription
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if traitCollection.horizontalSizeClass == .regular {
            NSLayoutConstraint.deactivate(landscapeLayoutConstraints)
            NSLayoutConstraint.activate(portraitLayoutConstraints)
        } else if traitCollection.horizontalSizeClass == .compact {
            NSLayoutConstraint.deactivate(portraitLayoutConstraints)
            NSLayoutConstraint.activate(landscapeLayoutConstraints)
        }
    }
}
