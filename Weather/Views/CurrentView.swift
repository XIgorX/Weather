//
//  CurrentView.swift
//  Weather
//
//  Created by Игорь Данильченко on 21.02.2026.
//

import UIKit

class CurrentView: UIView {
    
    let topLabel = UILabel()
    let imageView = UIImageView()
    let rightLabel = UILabel()
    let bottomLabel1 = UILabel()
    let bottomLabel2 = UILabel()
    
    private var currentWeatherData: CurrentWeather?
    
    // MARK: - Initialization
    // Инициализатор для программного создания
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // Инициализатор для создания из Storyboard/Xib
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Methods
    func configure(with data: CurrentWeather) {
        self.currentWeatherData = data
        reloadData()
    }
    
    // MARK: - Private Methods
    
    // Настройка внешнего вида
    private func setupView() {
        //backgroundColor = .systemBlue
        //layer.cornerRadius = 10
        
        // Верхний лейбл
        topLabel.text = "Заголовок"
        topLabel.numberOfLines = 0
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .center
        topLabel.font = UIFont.boldSystemFont(ofSize: 24.0)

        // Изображение слева
        imageView.image = UIImage(named: "example")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
  
        // Правый лейбл
        rightLabel.text = "Текст справа от картинки"
        rightLabel.numberOfLines = 0
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.textAlignment = .center
        rightLabel.font = UIFont.boldSystemFont(ofSize: 36.0)
        
        // Нижний лейбл 1
        bottomLabel1.text = "Первый нижний текст"
        bottomLabel1.numberOfLines = 0
        bottomLabel1.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel1.textAlignment = .center
        bottomLabel1.font = UIFont.boldSystemFont(ofSize: 18.0)

        // Нижний лейбл 2
        bottomLabel2.text = "Второй нижний текст"
        bottomLabel2.numberOfLines = 0
        bottomLabel2.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel2.textAlignment = .center
        bottomLabel2.font = UIFont.systemFont(ofSize: 18.0)
        
        addSubview(topLabel)
        addSubview(imageView)
        addSubview(rightLabel)
        addSubview(bottomLabel1)
        addSubview(bottomLabel2)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            topLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            // Изображение
            imageView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Правый лейбл (занимает оставшееся пространство)
            rightLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 16),
            rightLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rightLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor) // Выравнивание по вертикали
        ])
        
        NSLayoutConstraint.activate([
            // Первый нижний лейбл
            bottomLabel1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            bottomLabel1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            bottomLabel1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // Второй нижний лейбл
            bottomLabel2.topAnchor.constraint(equalTo: bottomLabel1.bottomAnchor, constant: 8),
            bottomLabel2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            bottomLabel2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            bottomLabel2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16) // Отступ от низа
        ])

    }
    
    private func reloadData() {
        if let currentWeatherData = currentWeatherData {
            topLabel.text = currentWeatherData.location
            if let url = URL(string: String("https:\(currentWeatherData.icon)")) {
                //imageView.load(url: url)
                imageView.loadImage(from: url, placeholder: UIImage(named: "placeholder"))
            }
            rightLabel.text = String(format: "%d °C", currentWeatherData.temperature)
            bottomLabel1.text = currentWeatherData.condition
            bottomLabel2.text = currentWeatherData.feelslike
        }
    }
}
