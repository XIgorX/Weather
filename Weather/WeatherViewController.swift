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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        currentView = CurrentView(frame: CGRect(x: 0, y: yOffset, width: Int(view.frame.width), height: currentViewHeight))
//        currentView.translatesAutoresizingMaskIntoConstraints = false
//        currentView.backgroundColor = .systemGreen

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
        self.currentView.changeText(newText: coordinates)
        self.coordinateLabel.text = coordinates
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: - CCLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            //let lat = location.coordinate.latitude
            //let lon = location.coordinate.longitude
            //weatherManager.fetchWeather(latitude: lat, longitude: lon)
            self.updateUI(with: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

