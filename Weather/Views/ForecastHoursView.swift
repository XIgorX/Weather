//
//  ForecastDaysView.swift
//  Weather
//
//  Created by Админ on 25.02.2026.
//

import UIKit

//class WeatherTodayTomorrowView: UIView {
//    
//    // MARK: - Properties
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Погода сегодня и завтра"
//        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        label.textColor = .label
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isPagingEnabled = false
//        scrollView.backgroundColor = .systemYellow
//        return scrollView
//    }()
//    
//    private let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 12
//        stackView.distribution = .fill
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.backgroundColor = .red
//        return stackView
//    }()
//    
//    private var hourlyWeatherData: [HourlyWeather] = []
//    
//    // MARK: - Initialization
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Public Methods
//    func configure(with data: [HourlyWeather]) {
//        self.hourlyWeatherData = data
//        updateHourlyWeatherCells()
//    }
//    
//    // MARK: - Private Methods
//    private func setupView() {
//        addSubview(titleLabel)
//        addSubview(scrollView)
//        scrollView.addSubview(stackView)
//        
//        setupConstraints()
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Title label constraints
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            
//            // Scroll view constraints
//            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
//            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            scrollView.heightAnchor.constraint(equalToConstant: 180),
//            
//            // Stack view constraints
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
//        ])
//    }
//    
//    private func updateHourlyWeatherCells() {
//        // Очистка существующих ячеек
//        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        
//        // Создание ячеек для каждого часа
//        for weather in hourlyWeatherData {
//            let cell = createHourlyWeatherCell(for: weather)
//            cell.backgroundColor = .systemBlue
//            stackView.addArrangedSubview(cell)
//        }
//        
//        // Гарантируем обновление layout перед расчётом contentSize
//        layoutIfNeeded()
//        
//        // Обновление контента скролла
////        scrollView.contentSize = CGSize(
////            width: scrollView.frame.size.width,//CGFloat(hourlyWeatherData.count) * (80 + 12) - 12,
////            height: 180
////        )
//        
//        // Обновляем contentSize на основе фактической ширины stackView
//        scrollView.contentSize = CGSize(
//            width: stackView.frame.width,
//            height: scrollView.frame.height
//        )
//    }
//    
//    private func createHourlyWeatherCell(for weather: HourlyWeather) -> UIView {
//        let cell = UIView()
//        cell.backgroundColor = UIColor.systemBackground
//        cell.layer.cornerRadius = 8
//        cell.clipsToBounds = true
//        cell.translatesAutoresizingMaskIntoConstraints = false
//        
//        let timeLabel = UILabel()
//        timeLabel.text = weather.time
//        timeLabel.font = UIFont.systemFont(ofSize: 12)
//        timeLabel.textColor = .secondaryLabel
//        timeLabel.textAlignment = .center
//        timeLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        let iconImageView = UIImageView()
//        //iconImageView.image = weather.condition.icon
//        iconImageView.contentMode = .scaleAspectFit
//        iconImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let chanceLabel = UILabel()
//        //chanceLabel.text = "\(weather.chance)%\nвероятность"
//        chanceLabel.font = UIFont.systemFont(ofSize: 9)
//        chanceLabel.textColor = .tertiaryLabel
//        chanceLabel.textAlignment = .center
//        chanceLabel.numberOfLines = 2
//        chanceLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        let temperatureLabel = UILabel()
//        //temperatureLabel.text = "\(weather.temperature)°"
//        temperatureLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        temperatureLabel.textColor = .label
//        temperatureLabel.textAlignment = .center
//        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        let verticalStack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, chanceLabel, temperatureLabel])
//        verticalStack.axis = .vertical
//        verticalStack.spacing = 4
//        verticalStack.alignment = .center
//        verticalStack.translatesAutoresizingMaskIntoConstraints = false
//        
//        cell.addSubview(verticalStack)
//        
//        NSLayoutConstraint.activate([
//            verticalStack.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
//            verticalStack.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
//            verticalStack.widthAnchor.constraint(equalToConstant: 60),
//            iconImageView.heightAnchor.constraint(equalToConstant: 30),
//            timeLabel.heightAnchor.constraint(equalToConstant: 14),
//            chanceLabel.heightAnchor.constraint(equalToConstant: 28),
//            temperatureLabel.heightAnchor.constraint(equalToConstant: 20)
//        ])
//        
//        return cell
//    }
//}

import UIKit

class WeatherTodayTomorrowView: UIView {
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Погода сегодня и завтра"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: "HourlyWeatherCell")
        return collectionView
    }()
    
    private var hourlyWeatherData: [HourlyWeather] = []
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with data: [HourlyWeather]) {
        self.hourlyWeatherData = data
        collectionView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        setupConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherTodayTomorrowView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath) as? HourlyWeatherCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: hourlyWeatherData[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeatherTodayTomorrowView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}


