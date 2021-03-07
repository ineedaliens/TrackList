//
//  PopUpView.swift
//  TrackList
//
//  Created by Евгений Сергеевич on 01.01.2021.
//

import Foundation
import UIKit
import SwiftEntryKit

class popUpView: UIView {
    private let message: EKPopUpMessage
    
    private var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 32.5
        }
    }
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let actionButton = UIButton()
    
    init(with message: EKPopUpMessage) {
        self.message = message
        super.init(frame: UIScreen.main.bounds)
        
        setupElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func actionButtonPressed() {
        message.action()
    }
}
// setup view
extension popUpView {
    func setupElements() {
        titleLabel.content = message.title
        descriptionLabel.content = message.description
        actionButton.buttonContent = message.button
        
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        
        guard let themeImage = message.themeImage else { return }
        imageView = UIImageView()
        imageView.imageContent = themeImage.image
    }
}
// setup constraints
extension popUpView {
    func setupConstraints() {
        addSubview(imageView)
        imageView.layoutToSuperview(.centerX)
        imageView.layoutToSuperview(.top, offset: 40)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
        
        addSubview(descriptionLabel)
        descriptionLabel.layoutToSuperview(axis: .horizontally, offset: 30)
        descriptionLabel.layout(.top, to: .bottom, of: titleLabel, offset: 16)
        descriptionLabel.forceContentWrap(.vertically)
        
        addSubview(actionButton)
        let height: CGFloat = 45
        actionButton.set(.height, of: height)
        actionButton.layout(.top, to: .bottom, of: descriptionLabel, offset: 30)
        actionButton.layoutToSuperview(.bottom, offset: -30)
        actionButton.layoutToSuperview(.centerX)
        
        let buttonAttributes = message.button
        actionButton.buttonContent = buttonAttributes
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        actionButton.layer.cornerRadius = height * 0.5
    }
}
