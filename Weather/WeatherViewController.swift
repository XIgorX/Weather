//
//  ViewController.swift
//  Weather
//
//  Created by Игорь Данильченко on 21.02.2026.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private enum Constants {
        static let defaultLocation = CLLocation(latitude: 55.755864, longitude: 37.617698)
        static let minDistanceForUpdate: CLLocationDistance = 1000 // 1000 метров (1 км)
        static let maxAgeForLocation: TimeInterval = 60 // секунд
        static let minAccuracyForLocation: CLLocationAccuracy = 1000 // метров
        
        struct UI {
            static let yOffset: CGFloat = 60
            static let currentViewHeight: CGFloat = 200
            static let coordinateLabelHeight: CGFloat = 32
            static let weatherViewHeight: CGFloat = 240
            static let tableViewHeight: CGFloat = 240
        }
    }
    
    private var lastKnownLocation: CLLocation?
    private let showLocationPanel = false
    
    private var currentView = CurrentView()
    private var coordinateLabel = UILabel()
    private var weatherView = WeatherTodayTomorrowByHoursView()
    private var weatherTableView = Weather3DaysTableView()
    private lazy var loadingVC: LoadingViewController = {
        let vc = LoadingViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }()
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    private var currentWeatherTask: Task<Void, Error>?
    
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
    
    deinit {
        currentWeatherTask?.cancel()
    }
    
    private func setupScrollViewAndStackView() {
        // Настройка scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        ])
    }

    private func setupCoordinateLabel() {
        coordinateLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinateLabel.backgroundColor = .systemBlue
        coordinateLabel.textAlignment = .center
        coordinateLabel.text = "Координаты"
        
        // Фиксированная высота
        coordinateLabel.heightAnchor.constraint(equalToConstant: CGFloat(Constants.UI.coordinateLabelHeight)).isActive = true
        
        // Добавляем в stackView как первый элемент
        stackView.addArrangedSubview(coordinateLabel)
    }

    private func setupCurrentView() {
        currentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Фиксированная высота currentViewHeight
        currentView.heightAnchor.constraint(equalToConstant: CGFloat(Constants.UI.currentViewHeight)).isActive = true
        
        // Добавляем в stackView после coordinateLabel
        stackView.addArrangedSubview(currentView)
    }

    private func setupWeatherView() {
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        
        // Фиксированная высота weatherViewHeight
        weatherView.heightAnchor.constraint(equalToConstant: Constants.UI.weatherViewHeight).isActive = true
        
        // Добавляем в stackView
        stackView.addArrangedSubview(weatherView)
    }

    private func setupWeatherTableView() {
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Для таблицы нужно задать фиксированную высоту или динамически вычисляемую
        weatherTableView.heightAnchor.constraint(equalToConstant: Constants.UI.tableViewHeight).isActive = true
        
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
            guard location.horizontalAccuracy <= Constants.minAccuracyForLocation else {
                print("Низкая точность: \(location.horizontalAccuracy) м")
                return
            }
                
            // 2. Проверяем возраст локации (не старше 60 секунд)
            let age = Date().timeIntervalSince(location.timestamp)
            guard age < Constants.maxAgeForLocation else {
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
            if distance >= Constants.minDistanceForUpdate {
                lastKnownLocation = location
                getWeatherByLocation(location: location)
            }
        } else {
            print("Нет данных о локации")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Геолокация отключена. Будет использована Москва как локация по умолчанию.",
            message: "Для точного прогноза погоды включите доступ к геолокации в настройках.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            locationManager(manager, didUpdateLocations: [Constants.defaultLocation])
            showLocationPermissionAlert()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            locationManager(manager, didUpdateLocations: [Constants.defaultLocation])
        }
    }
}

//MARK: - fetching and displaying weather

extension WeatherViewController {
    
    private func getWeatherByLocation(location: CLLocation)
    {
        self.updateUI(with: location)
        
        // показ загрузки
        loadingVC.onRetry = { [weak self] in
            self?.retryLoading(location: location)
        }
        DispatchQueue.main.async {
            if self.presentedViewController == nil { self.present(self.loadingVC, animated: true, completion: nil) }
        }
        
        //запрос погоды по геолокации
        fetchWeather(location: location)
    }
    
    private func fetchWeather(location: CLLocation) {
        currentWeatherTask?.cancel()
        currentWeatherTask = Task { [weak self] in
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = formatter.date(from: time) else {
            return "--"
        }
        
        formatter.dateFormat = "HH"
        return formatter.string(from: date)
    }

    
    private func displayHourlyWeather(localTime: String, forecast: Forecast) {
        let currentHour = Int(getHoursFromTimeString(localTime)) ?? 0
        var data: [HourlyWeather] = []
        
        let daysToProcess = forecast.forecastday.prefix(2)
        
        for (dayIndex, day) in daysToProcess.enumerated() {
            let hoursToProcess = dayIndex == 0 ? Array(day.hour[currentHour...]) : day.hour
            
            for hourElement in hoursToProcess {
                let time = getHoursFromTimeString(hourElement.time)
                data.append(HourlyWeather(
                    time: time,
                    icon: hourElement.condition.icon,
                    chance: max(Int(hourElement.chance_of_rain), Int(hourElement.chance_of_snow)),
                    temperature: Int(hourElement.temp_c)
                ))
            }
        }
        weatherView.configure(with: data)
    }
    
    private func displayDailyWeather(_ forecast: Forecast) {
        
        var data: [DailyWeather] = []
        let days = ["Сегодня", "Завтра", "Послезавтра"]
        
        for (index, forecastDayElement) in forecast.forecastday.prefix(3).enumerated() {
            data.append(DailyWeather(day: days[index], icon: forecastDayElement.day.condition.icon, minTemperature: Int(forecastDayElement.day.mintemp_c), maxTemperature: Int(forecastDayElement.day.maxtemp_c)))
        }

        weatherTableView.configure(with: data)
    }
    
}


