//
//  WeatherDetailsViewController.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 27.08.21.
//

import UIKit

protocol WeatherDetailsView {
    func configure(with model: WeatherDetailsViewModel)
    func showSharePopUp(description: WeatherDescriptionViewModel?)
    func displayError(error: Error)
}

class WeatherDetailsViewController: UIViewController, WeatherDetailsView, UICollectionViewDataSource {
    
    var presenter: WeatherDetailsPresentation!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignBook.Color.Foreground.light.uiColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let topSeparatorViews: UIStackView = {
        let purpleDashedView = DashedLineView()
        purpleDashedView.dashColor = DesignBook.Color.Foreground.purple.uiColor()
        purpleDashedView.backgroundColor = .clear
        purpleDashedView.perDashLength = 4
        purpleDashedView.spaceBetweenDash = 4
        purpleDashedView.contentMode = .redraw
        
        let orangeDashedView = DashedLineView()
        orangeDashedView.dashColor = DesignBook.Color.Foreground.orange.uiColor()
        orangeDashedView.backgroundColor = .clear
        orangeDashedView.perDashLength = 4
        orangeDashedView.spaceBetweenDash = 4
        orangeDashedView.contentMode = .redraw
        
        let greenDashedView = DashedLineView()
        greenDashedView.dashColor = DesignBook.Color.Foreground.green.uiColor()
        greenDashedView.backgroundColor = .clear
        greenDashedView.perDashLength = 4
        greenDashedView.spaceBetweenDash = 4
        greenDashedView.contentMode = .redraw
        
        let blueDashedView = DashedLineView()
        blueDashedView.dashColor = DesignBook.Color.Foreground.blue.uiColor()
        blueDashedView.backgroundColor = .clear
        blueDashedView.perDashLength = 4
        blueDashedView.spaceBetweenDash = 4
        blueDashedView.contentMode = .redraw
        
        let yellowDashedView = DashedLineView()
        yellowDashedView.dashColor = DesignBook.Color.Foreground.yellow.uiColor()
        yellowDashedView.backgroundColor = .clear
        yellowDashedView.perDashLength = 4
        yellowDashedView.spaceBetweenDash = 4
        yellowDashedView.contentMode = .redraw
        
        let redDashedView = DashedLineView()
        redDashedView.dashColor = DesignBook.Color.Foreground.red.uiColor()
        redDashedView.backgroundColor = .clear
        redDashedView.perDashLength = 4
        redDashedView.spaceBetweenDash = 4
        redDashedView.contentMode = .redraw
        
        let stack = UIStackView(arrangedSubviews: [purpleDashedView, orangeDashedView, greenDashedView, yellowDashedView, redDashedView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let descriptionView = WeatherDescriptionView()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    let parametersView: UICollectionView = {
        let layout  = CenterAlignedCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 92, height: 64)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = DesignBook.Color.Background.list.uiColor()
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
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setupTitleLabel()
        setupTopSeparator()
        setupDescriptionView()
        setupStackView()
        setupParametersView()
        setupShareView()
    }
    
    private func setupTitleLabel() {
        self.navigationItem.titleView = titleLabel
    }
    
    private func setupTopSeparator() {
        
        view.addSubview(topSeparatorViews)
        topSeparatorViews.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSeparatorViews.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSeparatorViews.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSeparatorViews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topSeparatorViews.heightAnchor.constraint(equalToConstant: 2)
        ])
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
                                forCellWithReuseIdentifier: WeatherPropertyCellViewModel.resuableId)
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
    
    func showSharePopUp(description: WeatherDescriptionViewModel?) {
        
        guard let descriptionModel = description else { return }
        
        // Setting description
        let firstActivityItem = "\(descriptionModel.weatherDescription ?? ""), \(descriptionModel.locationDescription ?? "")"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)
        
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.postToFacebook
        ]
        
        self.present(activityViewController, animated: true, completion: nil)

            
    }
    
    func displayError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource conformance
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parameters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherPropertyCellViewModel.resuableId, for: indexPath)
        if let propertyCell = cell as? WeatherPropertyCollectionViewCell {
            propertyCell.configure(with: parameters[indexPath.row])
        }
        return cell
    }
}
