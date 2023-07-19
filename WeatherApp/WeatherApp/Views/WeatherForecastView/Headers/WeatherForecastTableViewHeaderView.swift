//
//  WeatherForecastTableViewHeaderView.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 01.09.21.
//

import UIKit
import SkeletonView

class WeatherForecastTableViewHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor(named: "color-background-list")
        setupSubviews()
        setupSkeletonParameters()
    }
    
    func setupSubviews() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupSkeletonParameters() {
        self.isSkeletonable = true
        contentView.isSkeletonable = true
        titleLabel.isSkeletonable = true
        titleLabel.lastLineFillPercent = 40
        titleLabel.text = "Section"
        titleLabel.skeletonTextLineHeight = .relativeToFont
    }
    
    func configure(with model: WeatherForecastTableViewHeaderViewModel) {
        titleLabel.text = model.title
    }
}
