//
//  WeatherDetailsViewController.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 27.08.21.
//

import UIKit

protocol WeatherDetailsView {
    func configure(with model: WeatherDetailsViewModel)
    func displayError(error: Error)
}

class WeatherDetailsViewController: UIViewController, WeatherDetailsView, UICollectionViewDataSource {
    
    var presenter: WeatherDetailsPresentation!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionView = WeatherDescriptionView()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let parametersView: UICollectionView = {
        let layout  = CenterAlignedCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 92, height: 64)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    let shareView: ShareView = ShareView()
    
    var parameters: [WeatherPropertyCellViewModel] = []
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        let icon = UIImage(named: "icon-weather-today")
        self.tabBarItem = UITabBarItem(title: "Today", image: icon, selectedImage: icon)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup Subviews
    private func setupView() {
        view.backgroundColor = UIColor(named: "color-background-main")
    }
    
    private func setupSubviews() {
        setupTitleLabel()
        setupDescriptionView()
        setupStackView()
        setupParametersView()
        setupShareView()
    }
    
    private func setupTitleLabel() {
        self.navigationItem.titleView = titleLabel
    }
    
    private func setupDescriptionView() {
        stackView.addArrangedSubview(descriptionView)
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupParametersView() {
        
        stackView.addArrangedSubview(parametersView)
        parametersView.dataSource = self
        parametersView.register(WeatherPropertyCollectionViewCell.self,
                                forCellWithReuseIdentifier: WeatherPropertyCollectionViewCell.resuableId)
    }
    
    private func setupShareView() {
        stackView.addArrangedSubview(shareView)
    }
    
    // MARK: - WeatherDetailsView conformance
    public func configure( with model: WeatherDetailsViewModel) {
        titleLabel.text = model.title
        descriptionView.configure(with: model.weatherDescription)
        configureWeatherParameters(parameters: model.wetherParameters)
        shareView.configure(with: "Share")
        shareView.buttonAction = { [weak self] button in
            self?.presenter?.shareWether()
        }
    }
    
    func configureWeatherParameters(parameters: [WeatherPropertyCellViewModel]) {
        self.parameters = parameters
        parametersView.reloadData()
    }
    
    func displayError(error: Error) {
        print("\(error.localizedDescription)")
    }
    
    // MARK: - UICollectionViewDataSource conformance
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parameters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherPropertyCollectionViewCell.resuableId, for: indexPath)
        if let propertyCell = cell as? WeatherPropertyCollectionViewCell {
            propertyCell.configure(with: parameters[indexPath.row])
        }
        return cell
    }
}
