//
//  CurrentView.swift
//  Weather
//
//  Created by Админ on 21.02.2026.
//

import UIKit

class CurrentView: UIView {
    
    let topLabel = UILabel()
    let imageView = UIImageView()
    let rightLabel = UILabel()
    let bottomLabel1 = UILabel()
    let bottomLabel2 = UILabel()
    
    // Инициализатор для программного создания
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // Инициализатор для создания из Storyboard/Xib
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Настройка внешнего вида
    private func setupView() {
        backgroundColor = .systemBlue
        //layer.cornerRadius = 10
        
        // Добавьте сюда другие элементы (label, image и т.д.)
        
        // Верхний лейбл
        topLabel.text = "Заголовок"
        topLabel.numberOfLines = 0
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .center

        // Изображение слева
        imageView.image = UIImage(named: "example")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Правый лейбл
        rightLabel.text = "Текст справа от картинки"
        rightLabel.numberOfLines = 0
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.textAlignment = .center

        // Нижний лейбл 1
        bottomLabel1.text = "Первый нижний текст"
        bottomLabel1.numberOfLines = 0
        bottomLabel1.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel1.textAlignment = .center

        // Нижний лейбл 2
        bottomLabel2.text = "Второй нижний текст"
        bottomLabel2.numberOfLines = 0
        bottomLabel2.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel2.textAlignment = .center
        
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
        
        //changeText(newText: "It works!")

    }
    
    func changeText(newText: String) {
        
//        DispatchQueue.main.async {
//                print("Обновление в главном потоке")
                self.topLabel.text = newText
//                print("Текст установлен: \(self.topLabel.text ?? "nil")")
//            }
    }
}
