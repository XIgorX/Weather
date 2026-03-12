//
//  HoursSectionHeaderView.swift
//  Weather
//
//  Created by Игорь Данильченко on 11.03.2026.
//

import UIKit

class HoursSectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "HoursSectionHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
