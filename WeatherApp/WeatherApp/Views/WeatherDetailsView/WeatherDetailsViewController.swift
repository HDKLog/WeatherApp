//
//  WeatherDetailsViewController.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 27.08.21.
//

import UIKit
import SkeletonView

protocol WeatherDetailsView {
    func configure(with model: WeatherDetailsViewModel)
    func startLoadingAnimation()
    func stopLoadingAnimation()
    func showSharePopUp(description: WeatherDescriptionViewModel?)
    func displayError(error: Error)
    func displayEmptyScreen()
}

class WeatherDetailsViewController: UIViewController, WeatherDetailsView {
    
    var presenter: WeatherDetailsPresentation!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignBook.Color.Foreground.light.uiColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let topSeparatorViews: UIStackView = {
        var arrangedSubviewsColors = [DesignBook.Color.Foreground.purple,
                                      DesignBook.Color.Foreground.orange,
                                      DesignBook.Color.Foreground.green,
                                      DesignBook.Color.Foreground.blue,
                                      DesignBook.Color.Foreground.yellow,
                                      DesignBook.Color.Foreground.red ]

        var arrangedSubviews = arrangedSubviewsColors.map {
            let dashedView = DashedLineView()
            dashedView.dashColor = $0.uiColor()
            dashedView.backgroundColor = .clear
            dashedView.perDashLength = 4
            dashedView.spaceBetweenDash = 4
            dashedView.contentMode = .redraw
            return dashedView
        }
        
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()


    let emptyViewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignBook.Image.Icon.Weather.compass.uiImage()
        return imageView
    }()

    let tapToReloadLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to reload"
        label.textColor = DesignBook.Color.Foreground.light.uiColor()
        return label
    }()

    lazy var emptyView: UIView = {
        let view = UIView()
        view.isHidden = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emptyViewDidTap))
        view.addGestureRecognizer(gestureRecognizer)
        return view
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
        
        let icon = DesignBook.Image.Icon.Weather.today.uiImage()
        self.tabBarItem = UITabBarItem(title: "Today", image: icon, selectedImage: icon)
    }
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupSkeletonParameters()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup Subviews
    private func setupView() {
        view.backgroundColor = DesignBook.Color.Background.main.uiColor()
    }
    
    private func setupSubviews() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setupTitleLabel()
        setupTopSeparator()
        setupDescriptionView()
        setupEmptyView()
        setupStackView()
        setupParametersView()
        setupShareView()
    }

    private func setupSkeletonParameters() {
        stackView.isSkeletonable = true
        parametersView.isSkeletonable = true
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

    private func setupEmptyView() {
        emptyView.isHidden = true
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        emptyView.addSubview(emptyViewImageView)
        emptyViewImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyViewImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyViewImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
        ])

        emptyView.addSubview(tapToReloadLabel)
        tapToReloadLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tapToReloadLabel.centerXAnchor.constraint(equalTo: emptyViewImageView.centerXAnchor),
            tapToReloadLabel.topAnchor.constraint(equalTo: emptyViewImageView.bottomAnchor, constant: 64),
        ])

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

    @objc
    private func emptyViewDidTap(sender: UIGestureRecognizer) {
        presenter.reloadData()
    }
    
    // MARK: - WeatherDetailsView conformance
    public func configure( with model: WeatherDetailsViewModel) {
        titleLabel.text = model.title
        descriptionView.configure(with: model.weatherDescription)
        configureWeatherParameters(parameters: model.wetherParameters)
        shareView.configure(with: "Share")
        shareView.buttonAction = { [weak self] button in
            self?.presenter?.shareWether(with: model.weatherDescription)
        }

        self.stackView.isHidden = false
        self.emptyView.isHidden = true
    }

    func startLoadingAnimation() {
        stackView.showAnimatedGradientSkeleton()
    }

    func stopLoadingAnimation() {
        stackView.hideSkeleton()
    }
    
    func configureWeatherParameters(parameters: [WeatherPropertyCellViewModel]) {
        self.parameters = parameters
        parametersView.reloadData()
    }
    
    func showSharePopUp(description: WeatherDescriptionViewModel?) {

        // Setting description
        guard let firstActivityItem = description?.sharedDescription else { return }

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

    func displayEmptyScreen() {
        self.stackView.isHidden = true
        self.emptyView.isHidden = false
    }
}
    // MARK: - UICollectionViewDataSource conformance
extension WeatherDetailsViewController: UICollectionViewDataSource {

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
