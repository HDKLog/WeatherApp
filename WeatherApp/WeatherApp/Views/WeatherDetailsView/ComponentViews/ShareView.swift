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
    
    let topSeparator: DashedLineView = {
        let separator = DashedLineView()
        separator.dashColor = DesignBook.Color.Foreground.light.uiColor()
        separator.backgroundColor = .clear
        separator.perDashLength = 4
        separator.spaceBetweenDash = 4
        separator.contentMode = .redraw
        return separator
    }()
    
    convenience init() {
        self.init(frame: .zero)
        setupSubViews()
    }
    
    private func setupSubViews() {
        setupSeparator()
        setupButton()
    }
    
    private func setupButton() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 6),
        ])
    }
    
    private func setupSeparator() {
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topSeparator)

        let height = topSeparator.heightAnchor.constraint(equalToConstant: 2)
        let top = topSeparator.topAnchor.constraint(equalTo: topAnchor)
        let leading = topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64)
        let trailing = topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64)

        trailing.priority = UILayoutPriority(999)


        NSLayoutConstraint.activate([ height, top, leading, trailing])
    }
    
    func configure(with model: String ) {
        button.setTitle(model, for: .normal)
    }
    
    @objc func shareDidTap(button: UIButton) {
        buttonAction?(button)
    }
}
