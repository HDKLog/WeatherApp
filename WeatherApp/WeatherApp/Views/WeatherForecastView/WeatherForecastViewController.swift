//
//  WeatherForecastViewController.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit
import SkeletonView

protocol WeatherForecastView {
    func configure(with model: WeatherForecastViewModel)
    func reloadList()
    func startLoadingAnimation()
    func stopLoadingAnimation()
    func displayError(error: Error)
}

class WeatherForecastViewController: UIViewController, WeatherForecastView {
    
    var presenter: WeatherForecastPresentation!
    
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
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 64
        table.rowHeight = 64
        table.sectionFooterHeight = 0
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.contentInset = UIEdgeInsets.zero
        table.register(WeatherForecastTableViewCell.self,
                       forCellReuseIdentifier: WeatherForecastTableViewCellModel.reuseId)
        table.register(WeatherForecastTableViewHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: WeatherForecastTableViewHeaderViewModel.reusableId)
        table.refreshControl = self.refreshControl
        return table
    }()

    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        return control
    }()
    
    var sections: [WeatherForecastViewModel.Section] = []
    
    convenience init(){
        self.init(nibName: nil, bundle: nil)
        
        setupTabBarItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupSubviews()
        setupSkeletonParameters()
        presenter?.viewDidLoad()
    }
    
    private func setupTabBarItem() {
        let icon = DesignBook.Image.Icon.Weather.forecast.uiImage()
        self.tabBarItem = UITabBarItem(title: "Forecast", image: icon, selectedImage: icon)
    }
    
    func setup() {
        if #available(iOS 14.0, *) {
            var bgConfig = UIBackgroundConfiguration.listPlainCell()
            bgConfig.backgroundColor = DesignBook.Color.Background.list.uiColor()
            UITableViewHeaderFooterView.appearance().backgroundConfiguration = bgConfig
            UITableViewCell.appearance().backgroundConfiguration = bgConfig
        }
        view.backgroundColor = DesignBook.Color.Background.list.uiColor()
    }
    
    private func setupSubviews() {
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setupTableView()
        setupTopSeparator()
    }

    private func setupSkeletonParameters() {
        tableView.isSkeletonable = true
        titleLabel.isSkeletonable = true
        titleLabel.lastLineFillPercent = 100
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
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc
    func refreshTable(sender: Any) {
        presenter?.reloadData()
    }
    
    func configure(with model: WeatherForecastViewModel) {
        titleLabel.text = model.title
        sections = model.sections
    }

    func displayError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
        self.refreshControl.endRefreshing()
    }

    func reloadList() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }

    func startLoadingAnimation() {
        tableView.showAnimatedGradientSkeleton()
        titleLabel.showAnimatedGradientSkeleton()
    }

    func stopLoadingAnimation() {
        tableView.hideSkeleton()
        titleLabel.hideSkeleton()
    }
}

extension WeatherForecastViewController: SkeletonTableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCellModel.reuseId)
        if let forecastCell = cell as? WeatherForecastTableViewCell {
            forecastCell.configure(with: sections[indexPath.section].rows[indexPath.row])
        }
        return cell ?? UITableViewCell()
    }
    

    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return sections.count
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        WeatherForecastTableViewCellModel.reuseId
    }
}

extension WeatherForecastViewController: SkeletonTableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherForecastTableViewHeaderViewModel.reusableId)
        if let forecastHeader = header as? WeatherForecastTableViewHeaderView {
            let model =  WeatherForecastTableViewHeaderViewModel(title: sections[section].title)
            forecastHeader.configure(with: model)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier?
    {
        WeatherForecastTableViewHeaderViewModel.reusableId
    }
}
