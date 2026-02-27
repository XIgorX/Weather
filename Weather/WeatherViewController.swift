//
//  ViewController.swift
//  Weather
//
//  Created by Админ on 21.02.2026.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var defaultLocation = CLLocation(
        latitude: 55.755864,  // Москва
        longitude: 37.617698
    )
    private let minDistanceForUpdate: CLLocationDistance = 1000  // 1000 метров (1 км)
    private var lastKnownLocation: CLLocation?

    private let yOffset = 60
    private let currentViewHeight = 200
    private let coordinateLabelHeight = 32
    
    private var currentView = CurrentView()
    private var coordinateLabel = UILabel()
    private var weatherView = WeatherTodayTomorrowView()
    private var weatherTableView = WeatherTableView()
    private var loadingVC = LoadingViewController()
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    // TODO: remove if don't need
    
    private func createColoredView(color: UIColor, height: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
    
    ///
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually  // Все View займут равное пространство
//        stackView.alignment = .fill
//        stackView.spacing = 12
//
//        // Создаём 4 View с разными размерами
//        let views = [
//            createColoredView(color: .systemBlue, height: 60),
//            createColoredView(color: .systemOrange, height: 80),
//            createColoredView(color: .systemPurple, height: 50),
//            createColoredView(color: .systemTeal, height: 70)
//        ]
//
//        // Массовое добавление
//        views.forEach { stackView.addArrangedSubview($0) }
//
//        // Настройка ограничений для StackView
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)

//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
//        ])
        
        currentView = CurrentView(frame: CGRect(x: 0, y: yOffset, width: Int(view.frame.width), height: currentViewHeight))
        currentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(currentView)

        NSLayoutConstraint.activate([
            currentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            currentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentView.heightAnchor.constraint(equalToConstant: CGFloat(currentViewHeight)) // высота 200 pt
        ])
        
        coordinateLabel = UILabel(frame: CGRect(x: 0, y: yOffset + currentViewHeight, width: Int(view.frame.width), height: coordinateLabelHeight))
        //coordinateLabel.backgroundColor = .red
        coordinateLabel.textAlignment = .center
        
        view.addSubview(coordinateLabel)
        
        // WeatherTodayTomorrowView
        //weatherView = WeatherTodayTomorrowView()
        view.addSubview(weatherView)

        // Настройка constraints для weatherView
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: coordinateLabel.bottomAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.heightAnchor.constraint(equalToConstant: 240)
        ])

        // Заполнение тестовыми данными
        let sampleData: [HourlyWeather] = [
            HourlyWeather(time: "Сейчас", icon: "//cdn.weatherapi.com/weather/64x64/night/266.png", chance: 10, temperature: 22),
            HourlyWeather(time: "19:00", icon: "//cdn.weatherapi.com/weather/64x64/night/266.png", chance: 20, temperature: 21),
            HourlyWeather(time: "20:00", icon: "//cdn.weatherapi.com/weather/64x64/night/266.png", chance: 40, temperature: 20),
            // Добавьте остальные часы по необходимости
        ]
        
        weatherView.configure(with: sampleData)
        
        // WeatherTableView (3 days)
        //weatherTableView = WeatherTableView()
        view.addSubview(weatherTableView)

        // Настройка constraints для weatherTableView
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: weatherView.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Заполнение тестовыми данными на 3 дня
//        let sampleData2: [DailyWeather] = [
//            DailyWeather(day: "Сегодня", icon: "//cdn.weatherapi.com/weather/64x64/day/176.png", minTemperature: 18, maxTemperature: 25),
//            DailyWeather(day: "Завтра", icon: "//cdn.weatherapi.com/weather/64x64/day/176.png", minTemperature: 17, maxTemperature: 23),
//            DailyWeather(day: "Послезавтра", icon: "//cdn.weatherapi.com/weather/64x64/day/176.png", minTemperature: 19, maxTemperature: 27)
//        ]
//
//        weatherTableView.configure(with: sampleData2)

        
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
    
    private func fetchWeather(location: CLLocation) {
        weatherService.fetchForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.loadingVC.dismiss(animated: true, completion: nil)
                    self?.displayWeather(weather)
                case .failure(let error):
                    self?.loadingVC.showError(with: error.errorDescription ?? "Не удалось загрузить данные.\nПроверьте подключение к сети.")
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
        displayHourlyWeather(weather.forecast)
        displayDailyWeather(weather.forecast)
    }

    private func displayCurrentWeather(location: Location, current: Current) {
        currentView.topLabel.text = location.name
        if let url = URL(string: String("https:\(current.condition.icon)")) {
            currentView.imageView.load(url: url)
        }
        currentView.rightLabel.text = "\(current.temp_c) °C"
        currentView.bottomLabel1.text = current.condition.text
        currentView.bottomLabel2.text = "Feels like \(current.feelslike_c) °C"
    }
    
    private func displayHourlyWeather(_ forecast: Forecast) {
        
        var data: [HourlyWeather] = []

        for (dayIndex, forecastDayElement) in forecast.forecastday.enumerated() {
            
            for (hourIndex, hourElement) in forecastDayElement.hour.enumerated() {
                
                // получаем время в часах
                // проверяем, что в строке хотя бы 5 символов, чтобы избежать ошибки
                var time = hourElement.time
                if time.count >= 5 {
                    let start = time.index(time.endIndex, offsetBy: -5)
                    let end = time.index(start, offsetBy: 2) // Берем 2 символа вперед
                    
                    time = String(time[start..<end])
                } else {
                    time = "--"
                }
                
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


