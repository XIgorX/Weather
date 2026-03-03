//
//  LoadingViewController.swift
//  Weather
//
//  Created by Игорь Данильченко on 23.02.2026.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleTopMargin,
            .flexibleBottomMargin
        ]
        return indicator
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.8
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleTopMargin,
            .flexibleBottomMargin
        ]
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Повторить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemOrange
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleTopMargin,
            .flexibleBottomMargin
        ]
        return button
    }()
    
    // Обработчик нажатия кнопки «Повторить»
    var onRetry: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, at: 0)
        
        // Добавляем индикатор загрузки
        activityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY - 40
        )
        view.addSubview(activityIndicator)
        
        // Настраиваем кнопку повторного запроса
        retryButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 120,
            height: 44
        )
        retryButton.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY + 60
        )
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(retryButton)
        
        // Позиционируем метку с ошибкой
        errorLabel.frame = CGRect(
            x: 40,
            y: 0,
            width: view.bounds.width - 80,
            height: 60
        )
        errorLabel.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        view.addSubview(errorLabel)
        
        hideErrorState()
    }
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
    
    // Показ состояния загрузки
    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.errorLabel.isHidden = true
            self.retryButton.isHidden = true
        }
    }
    
    // Показ ошибки с сообщением
    func showError(with message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            self.errorLabel.text = message
            self.errorLabel.isHidden = false
            
            self.retryButton.isHidden = false
        }
    }
    
    // Скрытие всех элементов (завершение)
    func hide() {
        dismiss(animated: true, completion: nil)
    }
    
    // Вспомогательные методы для управления видимостью
    private func hideErrorState() {
        errorLabel.isHidden = true
        retryButton.isHidden = true
    }
}


