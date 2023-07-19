//
//  WeatherDescriptionView.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit
import SkeletonView

class WeatherDescriptionView: UIView {
    
    let weatherImage =  UIImageView()
    
    let locationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignBook.Color.Foreground.inverse.uiColor()
        return label
    }()
    
    let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignBook.Color.Foreground.highlited.uiColor()
        label.font = UIFont.systemFont(ofSize: 23)
        return label
    }()
    
    let bottomSeparator: DashedLineView = {
        let separator = DashedLineView()
        separator.dashColor = DesignBook.Color.Foreground.light.uiColor()
        separator.backgroundColor = .clear
        separator.perDashLength = 4
        separator.spaceBetweenDash = 4
        separator.contentMode = .redraw
        return separator
    }()
    
    var portraitLayoutConstraints: [NSLayoutConstraint] = []
    var landscapeLayoutConstraints: [NSLayoutConstraint] = []

    convenience init() {
        self.init(frame: .zero)
        setupSubViews()
        setupSkeletonParameters()
    }
    
    private func setupSubViews() {
        
        setupWeatherImageView()
        setupLocationDescriptionLabel()
        setupWeatherDescriptionLabel()
        setupSeparator()
        modifyConstraints()
    }

    private func setupSkeletonParameters() {
        self.isSkeletonable = true

        weatherImage.isSkeletonable = true

        locationDescriptionLabel.isSkeletonable = true
        locationDescriptionLabel.lastLineFillPercent = 100

        weatherDescriptionLabel.isSkeletonable = true
        weatherDescriptionLabel.lastLineFillPercent = 100

        bottomSeparator.isSkeletonable = true
        bottomSeparator.isHiddenWhenSkeletonIsActive = true
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
    
    private func setupSeparator() {
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomSeparator)

        let height = bottomSeparator.heightAnchor.constraint(equalToConstant: 2)
        let bottom = bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64)
        let trailing = bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64)

        trailing.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([ height, leading, trailing, bottom])
    }
    
    func configure(with model:WeatherDescriptionViewModel?) {
        guard let viewModel = model else { return }
        
        viewModel.weatherIconLoader?.loadDataForIcon(named: viewModel.weatherIconName) { [weak self] data in
            self?.weatherImage.image = UIImage(data: data)
        }

        locationDescriptionLabel.text = viewModel.locationDescription
        weatherDescriptionLabel.text = viewModel.weatherDescription?.description
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        modifyConstraints()
    }
    
    private func modifyConstraints() {
        if traitCollection.verticalSizeClass == .compact {
            NSLayoutConstraint.deactivate(portraitLayoutConstraints)
            NSLayoutConstraint.activate(landscapeLayoutConstraints)
        } else {
            NSLayoutConstraint.deactivate(landscapeLayoutConstraints)
            NSLayoutConstraint.activate(portraitLayoutConstraints)
        }
    }
}
