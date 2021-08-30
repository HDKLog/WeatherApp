//
//  ShareButtonView.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

class ShareView: UIView {
    
    lazy var button: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Share", for: .normal)
        return button
    }()
    
    convenience init() {
        self.init(frame: .zero)
        setupSubViews()
    }
    
    private func setupSubViews() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 6),
        ])
    }
}
