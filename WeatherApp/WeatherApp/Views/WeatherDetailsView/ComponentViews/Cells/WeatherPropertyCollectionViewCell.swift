//
//  WeatherPropertyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 29.08.21.
//

import UIKit

class WeatherPropertyCollectionViewCell: UICollectionViewCell {
    
    let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = DesignBook.Color.Foreground.element.uiColor()
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentViews() {
        self.contentView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        self.contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
    
    
    func configure(with model: WeatherPropertyCellViewModel) {
        iconView.image = model.icon?.withRenderingMode(.alwaysTemplate)
        descriptionLabel.text = model.description
    }
}
