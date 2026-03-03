//
//  DailyWeatherCell.swift
//  Weather
//
//  Created by Игорь Данильченко on 26.02.2026.
//

import UIKit

class DailyWeatherCell: UITableViewCell {
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureRangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(temperatureRangeLabel)
        
        NSLayoutConstraint.activate([
            // День (слева)
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Иконка погоды (по центру)
            weatherIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIcon.widthAnchor.constraint(equalToConstant: 24),
            weatherIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Диапазон температур (справа)
            temperatureRangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temperatureRangeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with weather: DailyWeather) {
        dayLabel.text = weather.day
        if let url = URL(string: "https:\(weather.icon)") {
            //weatherIcon.load(url: url)
            weatherIcon.loadImage(from: url, placeholder: UIImage(named: "placeholder"))
        }
        temperatureRangeLabel.text = "\(weather.minTemperature)° / \(weather.maxTemperature)°"
    }
}

