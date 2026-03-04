//
//  HourlyWeatherCell.swift
//  Weather
//
//  Created by Игорь Данильченко on 26.02.2026.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let chanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .link
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = UIColor.systemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(chanceLabel)
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 90),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            
            chanceLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 0),
            chanceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: chanceLabel.bottomAnchor, constant: 4),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
    }
    
    func configure(with weather: HourlyWeather) {
        timeLabel.text = weather.time
        if let url = URL(string: "https:\(weather.icon)") {
            iconImageView.loadImage(from: url, placeholder: UIImage(named: "placeholder"))
        }
        
        let chance = weather.chance
        if chance != 0 {
            chanceLabel.isHidden = false
            chanceLabel.text = "\(chance)%"
        } else {
            chanceLabel.isHidden = true
            NSLayoutConstraint.activate([
                iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
        }
        
        temperatureLabel.text = "\(weather.temperature)°"
    }
}

