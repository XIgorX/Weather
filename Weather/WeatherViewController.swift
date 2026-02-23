//
//  ViewController.swift
//  Weather
//
//  Created by Админ on 21.02.2026.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let yOffset = 60
    private let currentViewHeight = 200
    private let coordinateLabelHeight = 32
    
    private var currentView = CurrentView()
    private var coordinateLabel = UILabel()
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        currentView = CurrentView(frame: CGRect(x: 0, y: yOffset, width: Int(view.frame.width), height: currentViewHeight))
//        currentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(currentView)

        NSLayoutConstraint.activate([
            currentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            currentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentView.heightAnchor.constraint(equalToConstant: CGFloat(currentViewHeight)) // высота 200 pt
        ])
        
        coordinateLabel = UILabel(frame: CGRect(x: 0, y: yOffset + currentViewHeight, width: Int(view.frame.width), height: coordinateLabelHeight))
        coordinateLabel.backgroundColor = .red
        coordinateLabel.textAlignment = .center
        
        view.addSubview(coordinateLabel)
        
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func updateUI(with location: CLLocation) {
        let coordinates = "Широта: \(location.coordinate.latitude), Долгота: \(location.coordinate.longitude)"
        self.coordinateLabel.text = coordinates
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            print("Некорректный URL")
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Проверка HTTP-статуса
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Некорректный ответ сервера")
                return nil
            }
            
            return UIImage(data: data)
        } catch {
            print("Ошибка загрузки: \(error)")
            return nil
        }
    }
}

//MARK: - CCLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.updateUI(with: location)
            
            locationManager.stopUpdatingLocation()
            weatherService.fetchCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let weather):
                            self?.displayWeather(weather)
                        case .failure(let error):
                            self?.showError(error.errorDescription ?? "Произошла ошибка")
                        }
                    }
                }
        }
    }
    
    private func displayWeather(_ weather: WeatherResponse) {
        currentView.topLabel.text = weather.location.name
        if let url = URL(string: String("https:\(weather.current.condition.icon)")) {
            currentView.imageView.load(url: url)
        }
        currentView.rightLabel.text = "\(weather.current.temp_c) °C"
        currentView.bottomLabel1.text = weather.current.condition.text
        currentView.bottomLabel2.text = "Feels like \(weather.current.feelslike_c) °C"
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - loading image

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


