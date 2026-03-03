//
//  ViewController.swift
//  Weather
//
//  Created by Игорь Данильченко on 21.02.2026.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var defaultLocation = CLLocation(
        latitude: 55.755864,  // Москва
        longitude: 37.617698
    )
    private var lastKnownLocation: CLLocation?
    private let minDistanceForUpdate: CLLocationDistance = 1000  // 1000 метров (1 км)
    private let showLocationPanel = false

    private let yOffset = 60
    private let currentViewHeight = 200
    private let coordinateLabelHeight = 32
    
    private var currentView = CurrentView()
    private var coordinateLabel = UILabel()
    private var weatherView = WeatherTodayTomorrowView()
    private var weatherTableView = WeatherTableView()
    private var loadingVC = LoadingViewController()
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupScrollViewAndStackView()
        if showLocationPanel {
            setupCoordinateLabel()
        }
        setupCurrentView()
        setupWeatherView()
        setupWeatherTableView()
        setupLocationManager()
    }
    
    private func setupScrollViewAndStackView() {
        // Настройка scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Настройка stackView
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // Критически важно для прокрутки: высота stackView должна быть >= высоте scrollView
            stackView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
    }

    private func setupCoordinateLabel() {
        coordinateLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinateLabel.backgroundColor = .systemBlue
        coordinateLabel.textAlignment = .center
        coordinateLabel.text = "Координаты"
        
        // Фиксированная высота
        coordinateLabel.heightAnchor.constraint(equalToConstant: CGFloat(coordinateLabelHeight)).isActive = true
        
        // Добавляем в stackView как первый элемент
        stackView.addArrangedSubview(coordinateLabel)
    }

    private func setupCurrentView() {
        currentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Фиксированная высота 200 pt
        currentView.heightAnchor.constraint(equalToConstant: CGFloat(currentViewHeight)).isActive = true
        
        // Добавляем в stackView после coordinateLabel
        stackView.addArrangedSubview(currentView)
    }

    private func setupWeatherView() {
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        
        // Фиксированная высота 240 pt
        weatherView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        // Добавляем в stackView
        stackView.addArrangedSubview(weatherView)
    }

    private func setupWeatherTableView() {
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Для таблицы нужно задать фиксированную высоту или динамически вычисляемую
        weatherTableView.heightAnchor.constraint(equalToConstant: 250).isActive = true // Пример высоты
        
        // Добавляем в stackView последним
        stackView.addArrangedSubview(weatherTableView)
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
            // получили геолокацию
            
            // 1. Проверяем точность (в метрах)
            guard location.horizontalAccuracy <= 1000 else {
                print("Низкая точность: \(location.horizontalAccuracy) м")
                return
            }
                
            // 2. Проверяем возраст локации (не старше 60 секунд)
            let age = Date().timeIntervalSince(location.timestamp)
            guard age < 60 else {
                print("Старая локация: \(age) сек")
                return
            }
            
            // проверяем есть ли последняя сохранённая локация
            guard let lastLocation = lastKnownLocation else {
                lastKnownLocation = locations.last
                getWeatherByLocation(location: location)
                return
            }
            
            let distance = location.distance(from: lastLocation)
            if distance >= minDistanceForUpdate {
                lastKnownLocation = location
                getWeatherByLocation(location: location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            locationManager(manager, didUpdateLocations: [defaultLocation])
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            locationManager(manager, didUpdateLocations: [defaultLocation])
        }
    }
}

//MARK: - fetching and displaying weather

extension WeatherViewController {
    
    private func getWeatherByLocation(location: CLLocation)
    {
        self.updateUI(with: location)
        
        // показ загрузки
        loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        loadingVC.onRetry = { [weak self] in
            self?.retryLoading(location: location)
        }
        DispatchQueue.main.async {
            if self.presentedViewController == nil { self.present(self.loadingVC, animated: true, completion: nil) }
        }
        
        //запрос погоды по геолокации
        fetchWeather(location: location)
    }
    
//    private func fetchWeather(location: CLLocation) {
//        weatherService.fetchForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let weather):
//                    self?.loadingVC.dismiss(animated: true, completion: nil)
//                    self?.displayWeather(weather)
//                case .failure(let error):
//                    self?.loadingVC.showError(with: error.errorDescription ?? "Не удалось загрузить данные.\nПроверьте подключение к сети.")
//                }
//            }
//        }
//    }
    
    private func fetchWeather(location: CLLocation) {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let weather = try await self.weatherService.fetchForecast(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                
                await MainActor.run {
                    self.loadingVC.dismiss(animated: true, completion: nil)
                    self.displayWeather(weather)
                }
            } catch {
                await MainActor.run {
                    self.loadingVC.showError(
                        with: error.localizedDescription 
                    )
                }
            }
        }
    }

    
    private func retryLoading(location: CLLocation) {
        loadingVC.showLoading()
        fetchWeather(location: location)
    }
    
    private func displayWeather(_ weather: ForecastResponse) {
        displayCurrentWeather(location: weather.location, current: weather.current)
        displayHourlyWeather(localTime: weather.location.localtime, forecast: weather.forecast)
        displayDailyWeather(weather.forecast)
    }

    private func displayCurrentWeather(location: Location, current: Current) {
        currentView.configure(with: CurrentWeather(location: location.name, icon: current.condition.icon, temperature: Int(current.temp_c), condition: current.condition.text, feelslike: String(format: "Ощущается как %.0f °C", current.feelslike_c)))
    }
    
    private func getHoursFromTimeString(_ time: String) -> String {
        // проверяем, что в строке хотя бы 5 символов, чтобы избежать ошибки
        if time.count >= 5 {
            let start = time.index(time.endIndex, offsetBy: -5)
            let end = time.index(start, offsetBy: 2) // Берем 2 символа вперед
            
            return String(time[start..<end])
        } else {
            return "--"
        }
    }
    
    private func displayHourlyWeather(localTime: String, forecast: Forecast) {

        let currentHour = Int(getHoursFromTimeString(localTime)) ?? 0
        
        var data: [HourlyWeather] = []
        
        //оставшиеся часы первого дня
        if forecast.forecastday.count > 0
        {
            for hourElement in forecast.forecastday[0].hour[currentHour...] {
                
                // получаем время в часах
                var time = hourElement.time
                time = getHoursFromTimeString(time)
                
                data.append(HourlyWeather(time: time, icon: hourElement.condition.icon, chance: max(Int(hourElement.chance_of_rain), Int(hourElement.chance_of_snow)), temperature: Int(hourElement.temp_c)))
            }
        }
        
        //все часы второго дня
        if forecast.forecastday.count > 1
        {
            for hourElement in forecast.forecastday[1].hour {
                
                // получаем время в часах
                var time = hourElement.time
                time = getHoursFromTimeString(time)
                
                data.append(HourlyWeather(time: time, icon: hourElement.condition.icon, chance: max(Int(hourElement.chance_of_rain), Int(hourElement.chance_of_snow)), temperature: Int(hourElement.temp_c)))
            }
        }
        
        weatherView.configure(with: data)
    }
    
    private func displayDailyWeather(_ forecast: Forecast) {
        
        var data: [DailyWeather] = []
        let days = ["Сегодня", "Завтра", "Послезавтра"]
        
        for (index, forecastDayElement) in forecast.forecastday.enumerated() {
            data.append(DailyWeather(day: days[index], icon: forecastDayElement.day.condition.icon, minTemperature: Int(forecastDayElement.day.mintemp_c), maxTemperature: Int(forecastDayElement.day.maxtemp_c)))
        }

        weatherTableView.configure(with: data)
    }
    
}


