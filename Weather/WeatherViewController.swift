//
//  ViewController.swift
//  Weather
//
//  Created by Админ on 21.02.2026.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var currentView: CurrentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        let currentView = CurrentView(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: 200))
//        currentView.translatesAutoresizingMaskIntoConstraints = false
//        currentView.backgroundColor = .systemGreen

        view.addSubview(currentView)

        NSLayoutConstraint.activate([
            currentView.topAnchor.constraint(equalTo: view.topAnchor),
            currentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentView.heightAnchor.constraint(equalToConstant: 200) // высота 2000 pt
        ])

    }
}

