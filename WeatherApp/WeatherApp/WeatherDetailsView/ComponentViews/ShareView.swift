//
//  ShareButtonView.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

class ShareView: UIView {
    
    var buttonAction: ((UIButton) -> Void)?
    
    lazy var button: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitleColor(DesignBook.Color.Foreground.action.uiColor(), for: .normal)
        button.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
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
    
    func configure(with model: String ) {
        button.setTitle(model, for: .normal)
    }
    
    @objc func shareDidTap(button: UIButton) {
        buttonAction?(button)
    }
}
