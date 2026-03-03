//
//  ForecastDaysView.swift
//  Weather
//
//  Created by Игорь Данильченко on 26.02.2026.
//

import UIKit

class WeatherTableView: UIView {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Прогноз на 3 дня"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(DailyWeatherCell.self, forCellReuseIdentifier: "DailyWeatherCell")
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private var dailyWeatherData: [DailyWeather] = []
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods
    func configure(with data: [DailyWeather]) {
        self.dailyWeatherData = data
        tableView.reloadData()
    }
    // MARK: - Private Methods
    private func setupView() {
        addSubview(titleLabel)
        addSubview(tableView)
        setupConstraints()
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            // Table view constraints
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension WeatherTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(dailyWeatherData.count, 3) // Ограничиваем до 3 дней
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell", for: indexPath) as? DailyWeatherCell else {
            return UITableViewCell()
        }
        cell.configure(with: dailyWeatherData[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WeatherTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

