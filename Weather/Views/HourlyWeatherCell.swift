//
//  HourlyWeatherCell.swift
//  Weather
//
//  Created by Админ on 26.02.2026.
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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        // Сбрасываем состояние
//        chanceLabel.isHidden = true
//        // Также сбросьте другие изменяемые свойства
//    }
    
    private func setupCell() {
        contentView.backgroundColor = UIColor.systemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(chanceLabel)
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            //timeLabel.heightAnchor.constraint(equalToConstant: 14),
            
            iconImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            //iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            
            chanceLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 0),
            chanceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            chanceLabel.heightAnchor.constraint(equalToConstant: 28),
            
            temperatureLabel.topAnchor.constraint(equalTo: chanceLabel.bottomAnchor, constant: 4),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            //temperatureLabel.heightAnchor.constraint(equalToConstant: 20),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)//-8)
        ])
    }
    
    func configure(with weather: HourlyWeather) {
        timeLabel.text = weather.time
        if let url = URL(string: "https:\(weather.icon)") {
            //iconImageView.load(url: url)
            iconImageView.loadImage(from: url, placeholder: UIImage(named: "placeholder"))
        }
        
        let chance = weather.chance
        if chance != 0 {
            chanceLabel.isHidden = false
            chanceLabel.text = "\(chance)%"
        } else {
            chanceLabel.isHidden = true
            //chanceLabel.removeFromSuperview()
            NSLayoutConstraint.activate([
                iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
        }
        
        temperatureLabel.text = "\(weather.temperature)°"
    }
}

