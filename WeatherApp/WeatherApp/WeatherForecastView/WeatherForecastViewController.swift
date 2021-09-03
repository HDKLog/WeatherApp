//
//  WeatherForecastViewController.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

protocol WeatherForecastView {
    func configure(with model: WeatherForecastViewModel)
    func reloadList()
    func displayError(error: Error)
}

class WeatherForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WeatherForecastView {
    
    var presenter: WeatherForecastPresentation!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignBook.Color.Foreground.light.uiColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        return table
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
        
        presenter?.viewDidLoad()
    }
    
    private func setupTabBarItem() {
        let icon = UIImage(named: "icon-weather-forecast")
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
        
        setupTableView()
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
    
    func configure(with model: WeatherForecastViewModel) {
        titleLabel.text = model.title
        sections = model.sections
    }
    
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
    
    func displayError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadList() {
        self.tableView.reloadData()
    }

}
